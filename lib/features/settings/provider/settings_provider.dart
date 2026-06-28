import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/notification_service.dart';

const _keyNewMembers = 'notify_new_members';
const _keyContacts = 'notify_contacts';

@immutable
class SettingsState {
  final bool notifyNewMembers;
  final bool notifyContacts;

  const SettingsState({
    this.notifyNewMembers = false,
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
    final notifyNewMembers = _prefs.getBool(_keyNewMembers) ?? false;
    if (notifyNewMembers) {
      // Re-suscribe al topic en cada arranque por si cambió el token FCM
      NotificationService.subscribeToNewMembers();
    }
    return SettingsState(
      notifyNewMembers: notifyNewMembers,
      notifyContacts: _prefs.getBool(_keyContacts) ?? true,
    );
  }

  Future<void> toggleNotifyNewMembers() async {
    final current = state.valueOrNull?.notifyNewMembers ?? false;
    final next = !current;

    if (next) {
      // Solo activa si el sistema concede el permiso
      final granted = await NotificationService.requestPermission();
      if (granted) await NotificationService.subscribeToNewMembers();
      await _prefs.setBool(_keyNewMembers, granted);
      state = AsyncData(state.requireValue.copyWith(notifyNewMembers: granted));
    } else {
      await NotificationService.unsubscribeFromNewMembers();
      await _prefs.setBool(_keyNewMembers, false);
      state = AsyncData(state.requireValue.copyWith(notifyNewMembers: false));
    }
  }

  /// Sincroniza el toggle con el permiso real del sistema.
  /// Solo activa (false → true); nunca desactiva automáticamente.
  Future<void> syncPermissionStatus() async {
    final current = state.valueOrNull?.notifyNewMembers ?? false;
    if (current) return;
    final granted = await Permission.notification.isGranted;
    if (granted) {
      await _prefs.setBool(_keyNewMembers, true);
      state = AsyncData(state.requireValue.copyWith(notifyNewMembers: true));
    }
  }

  Future<void> toggleNotifyContacts() async {
    final current = state.valueOrNull?.notifyContacts ?? true;
    await _prefs.setBool(_keyContacts, !current);
    state = AsyncData(state.requireValue.copyWith(notifyContacts: !current));
  }

  Future<void> enableContactsNotification() async {
    await _prefs.setBool(_keyContacts, true);
    state = AsyncData(state.requireValue.copyWith(notifyContacts: true));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(
        SettingsNotifier.new);
