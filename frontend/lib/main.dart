import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(const SYEApp());
}

class SYEApp extends StatelessWidget {
  const SYEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SYE - Sell Your Yield',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}