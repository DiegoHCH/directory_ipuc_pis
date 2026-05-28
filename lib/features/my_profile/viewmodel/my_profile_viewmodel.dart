import 'package:flutter/foundation.dart';
import '../../directory/model/member.dart';

enum ProfileStatus { pendingReview, published, publishedVerified }

extension ProfileStatusLabel on ProfileStatus {
  String get label => switch (this) {
        ProfileStatus.pendingReview => 'EN REVISIÓN',
        ProfileStatus.published => 'PUBLICADO',
        ProfileStatus.publishedVerified => 'PUBLICADO · VERIFICADO',
      };
}

class ProfileStats {
  final int weeklyViews;
  final int whatsappContacts;
  final int activeServices;

  const ProfileStats({
    required this.weeklyViews,
    required this.whatsappContacts,
    required this.activeServices,
  });
}

class MyProfileViewModel extends ChangeNotifier {
  final Member member;
  final ProfileStatus status;
  final ProfileStats stats;

  MyProfileViewModel({
    required this.member,
    this.status = ProfileStatus.publishedVerified,
    this.stats = const ProfileStats(
      weeklyViews: 23,
      whatsappContacts: 7,
      activeServices: 5,
    ),
  });
}
