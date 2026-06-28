import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

/// Pantalla completa con la animación Lottie en loop.
/// Se muestra con [showLottieLoader] y se cierra internamente
/// cuando [task] completa, para luego ejecutar [onDone].
Future<void> showLottieLoader(
  BuildContext context, {
  required Future<void> Function() task,
  required VoidCallback onDone,
}) async {
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, a1, a2) => const _LottieLoaderScreen(),
    transitionBuilder: (ctx, anim, secondary, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
  );

  await task();

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop();
    onDone();
  }
}

class _LottieLoaderScreen extends StatelessWidget {
  const _LottieLoaderScreen();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.background,
      child: Center(
        child: Lottie.asset(
          'assets/loading_paperplane.json',
          width: 180,
          height: 180,
          repeat: true,
        ),
      ),
    );
  }
}
