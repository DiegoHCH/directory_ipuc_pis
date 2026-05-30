import 'package:flutter/foundation.dart';
import '../../directory/model/member.dart';

class EditProfileViewModel extends ChangeNotifier {
  final Member original;

  late String _name;
  late String _businessName;
  late MemberCategory _category;
  late List<String> _offers;
  late bool _visible;
  bool _isSaving = false;

  EditProfileViewModel(this.original) {
    _name = original.name;
    _businessName = original.description;
    _category = original.category == MemberCategory.all
        ? MemberCategory.emprendimiento
        : original.category;
    _offers = List.from(original.offers);
    _visible = true;
  }

  String get name => _name;
  String get businessName => _businessName;
  MemberCategory get category => _category;
  List<String> get offers => List.unmodifiable(_offers);
  bool get visible => _visible;
  bool get isSaving => _isSaving;

  bool get isDirty =>
      _name != original.name ||
      _businessName != original.description ||
      _category != original.category ||
      _visible != true ||
      _offers.length != original.offers.length ||
      !_offers.every(original.offers.contains);

  void setName(String v) {
    _name = v;
    notifyListeners();
  }

  void setBusinessName(String v) {
    _businessName = v;
    notifyListeners();
  }

  void setCategory(MemberCategory v) {
    _category = v;
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

  void toggleVisibility() {
    _visible = !_visible;
    notifyListeners();
  }

  Future<void> save() async {
    _isSaving = true;
    notifyListeners();

    // TODO: persistir cambios
    await Future.delayed(const Duration(milliseconds: 800));

    _isSaving = false;
    notifyListeners();
  }
}
