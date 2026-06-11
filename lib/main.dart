import 'package:flutter/material.dart';
import 'features/profile/screens/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,

      // Dark theme — navy colors
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF5B800),
          surface: Color(0xFF1B2B4B),
        ),
      ),

      // Light theme — clean white version
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0D1B2A),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF5B800),
          surface: Colors.white,
        ),
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ProfileScreen(
        onDarkModeToggle: (val) {
          setState(() {
            _isDarkMode = val;
          });
        },
      ),
    );
  }
}