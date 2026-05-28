import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/directory_viewmodel.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/member_card.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  late final DirectoryViewModel _viewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _viewModel = DirectoryViewModel();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final members = _viewModel.filteredMembers;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(totalMembers: _viewModel.totalMembers),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _SearchBar(
                    controller: _searchController,
                    onChanged: _viewModel.setSearchQuery,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CategoryFilterBar(
                    selected: _viewModel.selectedCategory,
                    onSelected: _viewModel.setCategory,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: members.length,
                    itemBuilder: (_, i) => MemberCard(member: members[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kAccentBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int totalMembers;

  const _Header({required this.totalMembers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA',
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz, color: kTextSecondary, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Directorio',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const Text(
            'Hermanos.',
            style: TextStyle(
              color: kAccentBlue,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '«Un Señor, una fe, un bautismo.» — $totalMembers hermanos ofreciendo su trabajo.',
            style: const TextStyle(color: kTextSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kTextSecondary.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: kTextPrimary, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Busca por nombre o servicio...',
          hintStyle: TextStyle(color: kTextSecondary, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: kTextSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
