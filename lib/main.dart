import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/directory/view/directory_screen.dart';

void main() {
  runApp(const DirectoryApp());
}

class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Directorio IPUC',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const DirectoryScreen(),
    );
  }
}
