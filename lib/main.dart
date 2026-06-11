import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/phone_frame.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const ALUConnectApp());
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
      home: const SplashScreen(),
    );
  }
}
