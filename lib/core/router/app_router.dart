import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/directory/model/member.dart';
import '../../features/directory/view/directory_screen.dart';
import '../../features/directory/view/member_profile_screen.dart';
import '../../features/edit_profile/view/edit_profile_screen.dart';
import '../../features/my_profile/view/my_profile_screen.dart';
import '../../features/register/view/register_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/verification/view/verification_screen.dart';

final routerProvider = Provider<GoRouter>(
  (_) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, _) => const DirectoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (ctx, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (ctx, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (ctx, _) => const VerificationScreen(),
      ),
      GoRoute(
        path: '/member',
        builder: (ctx, state) =>
            MemberProfileScreen(member: state.extra as Member),
      ),
      GoRoute(
        path: '/my-profile',
        builder: (ctx, state) =>
            MyProfileScreen(member: state.extra as Member),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (ctx, state) =>
            EditProfileScreen(member: state.extra as Member),
      ),
    ],
  ),
);
