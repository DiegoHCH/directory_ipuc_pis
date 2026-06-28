import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/directory/model/member.dart';
import '../../features/directory/view/directory_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/directory/view/member_profile_screen.dart';
import '../../features/directory/view/member_deep_link_screen.dart';
import '../../features/edit_profile/view/edit_profile_screen.dart';
import '../../features/my_profile/view/my_profile_screen.dart';
import '../../features/register/view/register_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>(
  (_) => GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (ctx, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/directory',
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
        path: '/login',
        builder: (ctx, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/member',
        builder: (ctx, state) {
          final extra = state.extra;
          if (extra is Member) return MemberProfileScreen(member: extra);
          final id = state.uri.queryParameters['id'] ?? '';
          return MemberDeepLinkScreen(memberId: id);
        },
      ),
      GoRoute(
        path: '/my-profile',
        builder: (ctx, _) => const MyProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (ctx, state) =>
            EditProfileScreen(member: state.extra as Member),
      ),
    ],
  ),
);
