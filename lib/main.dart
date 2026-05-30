import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/directory/view/directory_screen.dart';

void main() {
  runApp(const DirectoryApp());
}

class DirectoryApp extends StatefulWidget {
  const DirectoryApp({super.key});

  @override
  State<DirectoryApp> createState() => _DirectoryAppState();
}

class _DirectoryAppState extends State<DirectoryApp> {
  final _themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      notifier: _themeNotifier,
      child: ListenableBuilder(
        listenable: _themeNotifier,
        builder: (_, child) => MaterialApp(
          title: 'Directorio IPUC',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeNotifier.mode,
          home: const DirectoryScreen(),
        ),
      ),
    );
  }
}
