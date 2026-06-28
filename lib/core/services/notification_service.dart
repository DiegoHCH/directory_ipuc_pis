import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const _channelId = 'ipuc_directorio';
const _channelName = 'Directorio IPUC';

// URL del Cloudflare Worker — reemplazar tras hacer wrangler deploy
const _workerUrl = 'https://ipuc-notifications.educacion-cristiana-pis.workers.dev';
const _workerSecret = 'c20b1f503aa779f24837cc11354b62a6f700ac3004ed34d6f589d6b47cad9e29';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage _) async {}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _local.initialize(const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    ));

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
  }) =>
      _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
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

  static Future<void> subscribeToNewMembers() =>
      _messaging.subscribeToTopic('directorio_ipuc');

  static Future<void> unsubscribeFromNewMembers() =>
      _messaging.unsubscribeFromTopic('directorio_ipuc');

  /// Publica una notificación:
  /// - Escribe en Firestore → dispositivos con la app abierta la muestran
  /// - Llama al Cloudflare Worker → FCM push para dispositivos con app cerrada
  static Future<void> publish({
    required String title,
    required String body,
  }) async {
    await Future.wait([
      FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
      }),
      _pushViaWorker(title: title, body: body),
    ]);
  }

  static Future<void> _pushViaWorker({
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        Uri.parse(_workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'secret': _workerSecret,
        }),
      );
    } catch (_) {
      // No bloquea el registro si el Worker falla
    }
  }
}
