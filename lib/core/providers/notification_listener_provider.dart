import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// Escucha la colección `notifications` en Firestore y muestra una
/// notificación local cuando llega un documento nuevo (posterior al inicio).
final notificationListenerProvider = StreamProvider<void>((ref) {
  final since = Timestamp.now();

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('createdAt', isGreaterThan: since)
      .orderBy('createdAt')
      .snapshots()
      .asyncMap((snap) async {
    for (final change in snap.docChanges) {
      if (change.type != DocumentChangeType.added) continue;
      final data = change.doc.data();
      if (data == null) continue;
      await NotificationService.showLocal(
        title: data['title'] as String? ?? 'Directorio IPUC',
        body: data['body'] as String? ?? '',
      );
    }
  });
});
