import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/provider/settings_provider.dart';
import '../services/notification_service.dart';

/// Escucha nuevos registros en Firestore y muestra notificación local
/// solo si el usuario tiene activado "Avisarme de nuevos hermanos".
final notificationListenerProvider = StreamProvider<void>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  final enabled = settings?.notifyNewMembers ?? true;

  if (!enabled) return const Stream.empty();

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

/// Escucha cuando alguien contacta al usuario actual por WhatsApp
/// y muestra notificación local si tiene activado "Contactos a mi perfil".
final contactListenerProvider =
    StreamProvider.family<void, String>((ref, myId) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  final enabled = settings?.notifyContacts ?? true;

  if (!enabled || myId.isEmpty) return const Stream.empty();

  final since = Timestamp.now();

  return FirebaseFirestore.instance
      .collection('contact_events')
      .where('toId', isEqualTo: myId)
      .where('createdAt', isGreaterThan: since)
      .orderBy('createdAt')
      .snapshots()
      .asyncMap((snap) async {
    for (final change in snap.docChanges) {
      if (change.type != DocumentChangeType.added) continue;
      final data = change.doc.data();
      if (data == null) continue;
      final fromName = data['fromName'] as String? ?? 'Alguien';
      await NotificationService.showLocal(
        title: '¡Alguien quiere contactarte!',
        body: '$fromName vio tu perfil y abrió WhatsApp.',
      );
    }
  });
});
