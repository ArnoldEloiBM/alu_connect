import 'package:flutter/material.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/user_session.dart';
import 'theme/app_theme.dart';
import 'widgets/phone_frame.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  await UserSession.instance.init();
  await EventService.instance.init();
  await AuthService.clearCurrentUser();
  runApp(const ALUConnectApp());
}

class ALUConnectApp extends StatefulWidget {
  const ALUConnectApp({super.key, this.skipAuthForTesting = false});

  /// Lets widget tests land on the main shell without walking through login.
  @visibleForTesting
  final bool skipAuthForTesting;

  @override
  State<ALUConnectApp> createState() => _ALUConnectAppState();
}

class _ALUConnectAppState extends State<ALUConnectApp> {
  bool _isDarkMode = true;

  void _onDarkModeToggle(bool isDark) => setState(() => _isDarkMode = isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
      home: widget.skipAuthForTesting
          ? MainShell(onDarkModeToggle: _onDarkModeToggle)
          : SplashScreen(onDarkModeToggle: _onDarkModeToggle),
    );
  }
}
