import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/member.dart';

class DirectoryState {
  final String searchQuery;
  final MemberCategory selectedCategory;

  const DirectoryState({
    this.searchQuery = '',
    this.selectedCategory = MemberCategory.all,
  });

  int get totalMembers => mockMembers.length;

  List<Member> get filteredMembers => mockMembers.where((m) {
        final q = searchQuery.toLowerCase();
        final matchSearch = q.isEmpty ||
            m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q);
        final matchCategory = selectedCategory == MemberCategory.all ||
            m.category == selectedCategory;
        return matchSearch && matchCategory;
      }).toList();

  DirectoryState copyWith({String? searchQuery, MemberCategory? selectedCategory}) =>
      DirectoryState(
        searchQuery: searchQuery ?? this.searchQuery,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}

class DirectoryNotifier extends Notifier<DirectoryState> {
  @override
  DirectoryState build() => const DirectoryState();

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setCategory(MemberCategory cat) =>
      state = state.copyWith(selectedCategory: cat);
}

final directoryProvider =
    NotifierProvider<DirectoryNotifier, DirectoryState>(DirectoryNotifier.new);
