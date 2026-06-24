import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyNewMembers = 'notify_new_members';
const _keyContacts = 'notify_contacts';

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

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  Future<SettingsState> build() async {
    _prefs = await SharedPreferences.getInstance();
    return SettingsState(
      notifyNewMembers: _prefs.getBool(_keyNewMembers) ?? true,
      notifyContacts: _prefs.getBool(_keyContacts) ?? true,
    );
  }

  Future<void> toggleNotifyNewMembers() async {
    final current = state.valueOrNull?.notifyNewMembers ?? true;
    await _prefs.setBool(_keyNewMembers, !current);
    state = AsyncData(state.requireValue.copyWith(notifyNewMembers: !current));
  }

  Future<void> toggleNotifyContacts() async {
    final current = state.valueOrNull?.notifyContacts ?? true;
    await _prefs.setBool(_keyContacts, !current);
    state = AsyncData(state.requireValue.copyWith(notifyContacts: !current));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(
        SettingsNotifier.new);
