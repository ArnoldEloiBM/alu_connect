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

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) => PhoneFrame(child: child ?? const SizedBox()),
      home: const MainShell(),
    );
  }
}
