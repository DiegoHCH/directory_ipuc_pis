import 'package:flutter/foundation.dart';
import '../model/member.dart';

class DirectoryViewModel extends ChangeNotifier {
  final List<Member> _allMembers = List.unmodifiable(mockMembers);

  String _searchQuery = '';
  MemberCategory _selectedCategory = MemberCategory.all;

  String get searchQuery => _searchQuery;
  MemberCategory get selectedCategory => _selectedCategory;
  int get totalMembers => _allMembers.length;

  List<Member> get filteredMembers => _allMembers.where((m) {
        final q = _searchQuery.toLowerCase();
        final matchesSearch = q.isEmpty ||
            m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q);
        final matchesCategory = _selectedCategory == MemberCategory.all ||
            m.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(MemberCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
