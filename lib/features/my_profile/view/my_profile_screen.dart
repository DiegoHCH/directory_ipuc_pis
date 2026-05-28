import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../directory/model/member.dart';
import '../viewmodel/my_profile_viewmodel.dart';

class MyProfileScreen extends StatelessWidget {
  final Member member;

  const MyProfileScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final viewModel = MyProfileViewModel(member: member);
    return Scaffold(
      body: _MyProfileBody(viewModel: viewModel),
    );
  }
}

class _MyProfileBody extends StatelessWidget {
  final MyProfileViewModel viewModel;

  const _MyProfileBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _TopBar(status: viewModel.status),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(child: _LargeAvatar(initials: viewModel.member.initials)),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'MI PERFIL',
                      style: TextStyle(
                        color: kAccentBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      viewModel.member.name,
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      viewModel.member.description,
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StatsRow(stats: viewModel.stats),
                  const SizedBox(height: 24),
                  _OffersSection(member: viewModel.member),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _EditButton(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final ProfileStatus status;

  const _TopBar({required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kSurfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.chevron_left,
                    color: kTextPrimary, size: 22),
              ),
            ),
          ),
          _StatusBadge(status: status),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kSurfaceColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.ios_share,
                  color: kTextPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProfileStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeAvatar extends StatelessWidget {
  final String initials;

  const _LargeAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: kSurfaceColor,
        shape: BoxShape.circle,
        border: Border.all(color: kAccentBlue, width: 2.5),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: kAccentBlue,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ProfileStats stats;

  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatCell(value: '${stats.weeklyViews}', label: 'Vistas esta\nsemana'),
            _Divider(),
            _StatCell(value: '${stats.whatsappContacts}', label: 'Contactos por\nWhatsApp'),
            _Divider(),
            _StatCell(value: '${stats.activeServices}', label: 'Servicios\nactivos'),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;

  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: kTextPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kTextSecondary,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: kTextSecondary.withValues(alpha: 0.15),
      width: 1,
      indent: 12,
      endIndent: 12,
    );
  }
}

class _OffersSection extends StatelessWidget {
  final Member member;

  const _OffersSection({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LO QUE OFRECES',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'EDITAR',
                style: TextStyle(
                  color: kAccentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (member.offers.isEmpty)
          const Text(
            'Aún no has agregado servicios.',
            style: TextStyle(color: kTextSecondary, fontSize: 13),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: member.offers
                .map(
                  (offer) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: kAccentBlue.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      offer,
                      style: const TextStyle(
                          color: kTextPrimary, fontSize: 13),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text(
            'Editar mi perfil',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
