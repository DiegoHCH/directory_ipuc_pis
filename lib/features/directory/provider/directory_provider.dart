import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/member.dart';
import '../repository/member_repository.dart';

class DirectoryFilter {
  final String searchQuery;
  final MemberCategory selectedCategory;

  const DirectoryFilter({
    this.searchQuery = '',
    this.selectedCategory = MemberCategory.all,
  });

  DirectoryFilter copyWith({
      String? searchQuery, MemberCategory? selectedCategory}) =>
      DirectoryFilter(
        searchQuery: searchQuery ?? this.searchQuery,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}

class DirectoryNotifier extends Notifier<DirectoryFilter> {
  @override
  DirectoryFilter build() => const DirectoryFilter();

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setCategory(MemberCategory cat) =>
      state = state.copyWith(selectedCategory: cat);
}

final directoryProvider =
    NotifierProvider<DirectoryNotifier, DirectoryFilter>(DirectoryNotifier.new);

/// Lista filtrada combinando stream de Firestore + estado de filtros.
final filteredMembersProvider = Provider<AsyncValue<List<Member>>>((ref) {
  final membersAsync = ref.watch(membersStreamProvider);
  final filter = ref.watch(directoryProvider);

  return membersAsync.whenData((members) => members.where((m) {
        final q = filter.searchQuery.toLowerCase();
        final matchSearch = q.isEmpty ||
            m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q);
        final matchCategory = filter.selectedCategory == MemberCategory.all ||
            m.category == filter.selectedCategory;
        return matchSearch && matchCategory;
      }).toList());
});
