import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class SettingsState {
  final bool notifyNewMembers;
  final bool notifyContacts;

  const SettingsState({
    this.notifyNewMembers = true,
    this.notifyContacts = true,
  });

  SettingsState copyWith({bool? notifyNewMembers, bool? notifyContacts}) =>
      SettingsState(
        notifyNewMembers: notifyNewMembers ?? this.notifyNewMembers,
        notifyContacts: notifyContacts ?? this.notifyContacts,
      );
}

class SettingsNotifier extends AutoDisposeNotifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void toggleNotifyNewMembers() =>
      state = state.copyWith(notifyNewMembers: !state.notifyNewMembers);

  void toggleNotifyContacts() =>
      state = state.copyWith(notifyContacts: !state.notifyContacts);
}

final settingsProvider =
    AutoDisposeNotifierProvider<SettingsNotifier, SettingsState>(
        SettingsNotifier.new);
