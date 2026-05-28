import 'package:flutter/foundation.dart';
import '../model/member.dart';

class MemberProfileViewModel extends ChangeNotifier {
  final Member member;
  bool _bookmarked = false;

  MemberProfileViewModel(this.member);

  bool get bookmarked => _bookmarked;

  void toggleBookmark() {
    _bookmarked = !_bookmarked;
    notifyListeners();
  }

  String get whatsAppUrl {
    final digits = member.phone.replaceAll(RegExp(r'[^\d]'), '');
    return 'https://wa.me/$digits';
  }
}
