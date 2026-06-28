import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

/// Muestra loader Lottie mientras [task] corre.
/// [task] retorna true si fue exitoso.
/// Si fue exitoso Y se provee [successBuilder], transiciona a la pantalla
/// de éxito dentro del mismo diálogo (evita problemas de context desmontado).
/// Al cerrar la pantalla de éxito (o si no hay éxito), llama [onDone].
Future<void> showLottieLoader(
  BuildContext context, {
  required Future<bool> Function() task,
  required VoidCallback onDone,
  Widget Function(VoidCallback close)? successBuilder,
}) async {
  // Capturado antes de cualquier await — puede desmontarse (ej: deleteAccount).
  final navigator = Navigator.of(context, rootNavigator: true);
  final resultNotifier = ValueNotifier<bool?>(null);

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, a1, a2) => _LoaderPage(
      resultNotifier: resultNotifier,
      successBuilder: successBuilder,
      onClose: () {
        Navigator.of(ctx, rootNavigator: true).pop();
        onDone();
      },
    ),
    transitionBuilder: (ctx, anim, secondary, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
  );

  final success = await task();
  resultNotifier.value = success;

  if (!success || successBuilder == null) {
    navigator.pop();
    onDone();
  }
  // Si success && successBuilder != null, _LoaderPage transiciona internamente.
}

class _LoaderPage extends StatefulWidget {
  final ValueNotifier<bool?> resultNotifier;
  final Widget Function(VoidCallback close)? successBuilder;
  final VoidCallback onClose;

  const _LoaderPage({
    required this.resultNotifier,
    required this.onClose,
    this.successBuilder,
  });

  @override
  State<_LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<_LoaderPage> {
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    widget.resultNotifier.addListener(_onResult);
  }

  void _onResult() {
    final success = widget.resultNotifier.value;
    if (success == true && widget.successBuilder != null && mounted) {
      setState(() => _showSuccess = true);
    }
  }

  @override
  void dispose() {
    widget.resultNotifier.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess && widget.successBuilder != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.successBuilder!(widget.onClose),
      );
    }
    return const _LottieLoaderScreen(key: ValueKey('loader'));
  }
}

class _LottieLoaderScreen extends StatelessWidget {
  const _LottieLoaderScreen({super.key});

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
