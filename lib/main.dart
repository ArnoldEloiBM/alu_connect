import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'services/event_service.dart';
import 'services/user_session.dart';
import 'theme/app_theme.dart';
import 'widgets/phone_frame.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession.instance.init();
  await EventService.instance.init();
  runApp(const ALUConnectApp());
}

class ALUConnectApp extends StatefulWidget {
  const ALUConnectApp({super.key});

  @override
  State<ALUConnectApp> createState() => _ALUConnectAppState();
}

class _ALUConnectAppState extends State<ALUConnectApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
      home: MainShell(
        onDarkModeToggle: (isDark) => setState(() => _isDarkMode = isDark),
      ),
    );
  }
}
