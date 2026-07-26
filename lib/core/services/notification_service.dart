import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const _channelId = 'ipuc_directorio';
const _channelName = 'Directorio IPUC';

const _workerUrl = 'https://ipuc-notifications.educacion-cristiana-pis.workers.dev';

// Generar en: Firebase Console → Project Settings → Cloud Messaging → Web Push certificates
const vapidKey = 'BF7W-EQwoeQJ88paHXmY3ZBm08ttEeYd54vgsCms9de0n_qE40zRhqpr9yY-YDaDjvs-FBL5P7htlrn5TeFA46s';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage _) async {}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return;

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings();
    await _local.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> showLocal({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;
    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: DefaultStyleInformation(true, true),
        ),
      ),
    );
  }

  static Future<bool> requestPermission() async {
    if (kIsWeb) {
      final result = await _messaging.requestPermission();
      return result.authorizationStatus == AuthorizationStatus.authorized ||
          result.authorizationStatus == AuthorizationStatus.provisional;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      if (status.isGranted) return true;
      // Ya era permanente antes de pedir → abre ajustes y sale
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      // Muestra el diálogo nativo; si tras esta denegación queda
      // permanente, el siguiente tap lo detectará y abrirá ajustes
      final result = await Permission.notification.request();
      return result.isGranted;
    }

    // iOS
    final current = await _messaging.getNotificationSettings();
    if (current.authorizationStatus == AuthorizationStatus.authorized ||
        current.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    }
    // En iOS una vez denegado, solo se puede re-activar desde Ajustes
    if (current.authorizationStatus == AuthorizationStatus.denied) {
      await openAppSettings();
      return false;
    }
    final result = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return result.authorizationStatus == AuthorizationStatus.authorized ||
        result.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Guarda el token Android en Firestore para recibir push individualmente.
  /// Reemplaza la suscripción por topic (que no permite excluir tokens).
  static Future<void> subscribeToNewMembers() async {
    if (kIsWeb) return;
    // Limpia suscripción al topic viejo si aún existe
    try { await _messaging.unsubscribeFromTopic('directorio_ipuc'); } catch (_) {}
    final token = await _messaging.getToken();
    if (token == null) return;
    await FirebaseFirestore.instance.collection('fcm_tokens').doc(token).set({
      'token': token,
      'platform': 'android',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> unsubscribeFromNewMembers() async {
    if (kIsWeb) return;
    final token = await _messaging.getToken();
    if (token == null) return;
    await FirebaseFirestore.instance
        .collection('fcm_tokens')
        .doc(token)
        .delete();
  }

  /// Devuelve el FCM token del dispositivo actual (Android o web).
  static Future<String?> getCurrentToken() async {
    if (kIsWeb) return _messaging.getToken(vapidKey: vapidKey);
    return _messaging.getToken();
  }

  /// Registra el token FCM web en Firestore para recibir push en la PWA.
  static Future<void> registerWebToken() async {
    if (!kIsWeb) return;
    final token = await _messaging.getToken(vapidKey: vapidKey);
    if (token == null) return;
    await _saveWebToken(token);
    _messaging.onTokenRefresh.listen(_saveWebToken);
  }

  static Future<void> _saveWebToken(String token) =>
      FirebaseFirestore.instance.collection('fcm_tokens').doc(token).set({
        'token': token,
        'platform': 'web',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  static Future<void> unregisterWebToken() async {
    if (!kIsWeb) return;
    final token = await _messaging.getToken(vapidKey: vapidKey);
    if (token == null) return;
    await FirebaseFirestore.instance.collection('fcm_tokens').doc(token).delete();
    await _messaging.deleteToken();
  }

  /// Publica una notificación:
  /// - Escribe en Firestore → dispositivos con la app abierta la muestran
  /// - Llama al Cloudflare Worker → FCM push para dispositivos con app cerrada
  /// [excludeToken] excluye un token específico del push (para evitar
  /// que el dispositivo que dispara la notificación la reciba a sí mismo).
  static Future<void> publish({
    required String title,
    required String body,
    String? excludeToken,
    String? excludeUid,
  }) async {
    await Future.wait([
      FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
        'triggeredBy': ?excludeUid,
      }),
      _pushViaWorker(title: title, body: body, excludeToken: excludeToken),
    ]);
  }

  static Future<void> _pushViaWorker({
    required String title,
    required String body,
    String? excludeToken,
  }) async {
    try {
      // El Worker autentica con el ID token de Firebase: sin sesión no hay
      // notificación (y no hay ningún secreto embebido en el cliente).
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) return;

      await http.post(
        Uri.parse(_workerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'excludeToken': ?excludeToken,
        }),
      );
    } catch (_) {
      // No bloquea el registro si el Worker falla
    }
  }
}
