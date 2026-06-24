import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channelId = 'ipuc_directorio';
const _channelName = 'Directorio IPUC';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage _) async {}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

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

  /// Publica una notificación en Firestore para que todos los dispositivos
  /// activos la reciban vía stream.
  static Future<void> publish({
    required String title,
    required String body,
  }) =>
      FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
      });
}
