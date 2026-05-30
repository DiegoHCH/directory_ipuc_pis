import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProfileStatus { pendingReview, published, publishedVerified }

extension ProfileStatusLabel on ProfileStatus {
  String get label => switch (this) {
        ProfileStatus.pendingReview => 'EN REVISIÓN',
        ProfileStatus.published => 'PUBLICADO',
        ProfileStatus.publishedVerified => 'PUBLICADO · VERIFICADO',
      };
}

@immutable
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

// Estado del perfil propio (simulado, en producción vendría de un auth provider)
@immutable
class MyProfileState {
  final ProfileStatus status;
  final ProfileStats stats;

  const MyProfileState({
    this.status = ProfileStatus.publishedVerified,
    this.stats = const ProfileStats(
      weeklyViews: 23,
      whatsappContacts: 7,
      activeServices: 5,
    ),
  });
}

final myProfileProvider = Provider.autoDispose<MyProfileState>(
  (_) => const MyProfileState(),
);

// Provider para bookmark por miembro
final bookmarkProvider =
    StateProvider.autoDispose.family<bool, String>((ref, memberId) => false);
