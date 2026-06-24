import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/my_profile/provider/my_profile_provider.dart';

final profileStatsProvider =
    FutureProvider.autoDispose.family<ProfileStats, String>((ref, memberId) async {
  final sevenDaysAgo = Timestamp.fromDate(
    DateTime.now().subtract(const Duration(days: 7)),
  );

  final results = await Future.wait([
    FirebaseFirestore.instance
        .collection('profile_views')
        .where('memberId', isEqualTo: memberId)
        .where('createdAt', isGreaterThan: sevenDaysAgo)
        .count()
        .get(),
    FirebaseFirestore.instance
        .collection('contact_events')
        .where('toId', isEqualTo: memberId)
        .where('createdAt', isGreaterThan: sevenDaysAgo)
        .count()
        .get(),
  ]);

  return ProfileStats(
    weeklyViews: results[0].count ?? 0,
    whatsappContacts: results[1].count ?? 0,
    activeServices: 0, // se sobreescribe en la UI con member.offers.length
  );
});
