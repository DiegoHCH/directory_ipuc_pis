import 'package:flutter/foundation.dart';
import '../../directory/model/member.dart';
import '../model/register_form.dart';

class RegisterViewModel extends ChangeNotifier {
  String _name = '';
  MemberCategory? _category;
  String _bio = '';
  final List<String> _offers = [];
  String _phone = '';
  bool _isSubmitting = false;

  String get name => _name;
  MemberCategory? get category => _category;
  String get bio => _bio;
  List<String> get offers => List.unmodifiable(_offers);
  String get phone => _phone;
  bool get isSubmitting => _isSubmitting;

  bool get isValid =>
      _name.trim().isNotEmpty &&
      _category != null &&
      _phone.trim().isNotEmpty;

  void setName(String v) {
    _name = v;
    notifyListeners();
  }

  void setCategory(MemberCategory v) {
    _category = v;
    notifyListeners();
  }

  void setBio(String v) {
    _bio = v;
    notifyListeners();
  }

  void addOffer(String v) {
    final trimmed = v.trim();
    if (trimmed.isEmpty || _offers.contains(trimmed)) return;
    _offers.add(trimmed);
    notifyListeners();
  }

  void removeOffer(String v) {
    _offers.remove(v);
    notifyListeners();
  }

  void setPhone(String v) {
    _phone = v;
    notifyListeners();
  }

  RegisterForm buildForm() => RegisterForm(
        name: _name.trim(),
        category: _category!,
        bio: _bio.trim(),
        offers: List.from(_offers),
        phone: '+57${_phone.trim()}',
      );

  Future<void> submit() async {
    if (!isValid) return;
    _isSubmitting = true;
    notifyListeners();

    // TODO: enviar invitación por WhatsApp
    await Future.delayed(const Duration(seconds: 1));

    _isSubmitting = false;
    notifyListeners();
  }
}
