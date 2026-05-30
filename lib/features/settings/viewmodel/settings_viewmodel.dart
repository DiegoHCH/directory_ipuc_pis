import 'package:flutter/foundation.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _notifyNewMembers = true;
  bool _notifyContacts = true;

  bool get notifyNewMembers => _notifyNewMembers;
  bool get notifyContacts => _notifyContacts;

  void toggleNotifyNewMembers() {
    _notifyNewMembers = !_notifyNewMembers;
    notifyListeners();
  }

  void toggleNotifyContacts() {
    _notifyContacts = !_notifyContacts;
    notifyListeners();
  }
}
