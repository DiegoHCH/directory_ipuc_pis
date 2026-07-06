import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/provider/settings_provider.dart';
import '../services/notification_service.dart';

/// Escucha nuevos registros en Firestore y muestra notificación local
/// solo si el usuario tiene activado "Avisarme de nuevos hermanos".
final notificationListenerProvider = StreamProvider<void>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final enabled = settings?.notifyNewMembers ?? false;

  if (!enabled) return const Stream.empty();

  final since = Timestamp.now();
  final currentUid = FirebaseAuth.instance.currentUser?.uid;

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
      // No mostrar la notificación al usuario que la generó
      if (currentUid != null && data['triggeredBy'] == currentUid) continue;
      await NotificationService.showLocal(
        title: data['title'] as String? ?? 'Directorio IPUC',
        body: data['body'] as String? ?? '',
      );
    }
  });
});

