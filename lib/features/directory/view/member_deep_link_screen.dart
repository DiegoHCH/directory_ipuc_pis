import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/member.dart';
import '../repository/member_repository.dart';

class MemberDeepLinkScreen extends ConsumerWidget {
  final String memberId;
  const MemberDeepLinkScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Member?>(
      future: ref.read(memberRepositoryProvider).getByUid(memberId),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final member = snap.data;
        if (member == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/directory');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/directory');
          context.push('/member', extra: member);
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
