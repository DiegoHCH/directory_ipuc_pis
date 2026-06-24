import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/app_primitives.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../auth/repository/auth_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _navTimer = Timer(const Duration(seconds: 4), _navigate);
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  void _navigate() {
    if (!mounted) return;
    final user = ref.read(authRepositoryProvider).currentUser;
    context.go(user != null ? '/directory' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPrimitives.neutral900,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Center(
                child: Lottie.asset(
                  'assets/splash_animation.json',
                  controller: _controller,
                  onLoaded: _onLoaded,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 700),
              child: Text(
                context.l10n.dirTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.thin,
                      letterSpacing: 2,
                    ),
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 700),
              child: Text(
                'IPUC',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppPrimitives.brand400,
                      fontWeight: AppTypography.bold,
                      letterSpacing: 6,
                    ),
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 700),
              child: Text(
                'Pisarreal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: AppTypography.thin,
                      letterSpacing: 3,
                    ),
              ),
            ),
            const Spacer(),
            FadeIn(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 600),
              child: Text(
                context.l10n.splashTagline,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white38,
                      letterSpacing: 1,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
  }
}
