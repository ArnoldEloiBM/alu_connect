// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_widgets.dart';
import '../main_shell.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../services/auth_service.dart';
import '../../data/mock_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _serverError;

  // ── Validation ──────────────────────────────────────────
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // ── Submit ───────────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _serverError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1400)); // mock auth
    if (!mounted) return;
    setState(() => _loading = false);

    final email = _emailCtrl.text.trim();
    
    // Check if user profile exists; if not, auto-create a mock one based on email prefix
    final exists = await AuthService.hasUserProfile(email);
    String finalName;
    if (!exists) {
      String derivedName = 'Kwame Mensah';
      try {
        final prefix = email.split('@').first;
        final parts = prefix.split(RegExp(r'[._-]'));
        derivedName = parts.map((p) {
          if (p.isEmpty) return '';
          return p[0].toUpperCase() + p.substring(1).toLowerCase();
        }).join(' ');
      } catch (_) {}

      await AuthService.saveUserProfile(
        email: email,
        fullName: derivedName,
        role: 'student',
        isAlumni: false,
        intakeMonth: 'September',
        intakeYear: '2023',
        faculty: 'BSE',
      );
      finalName = derivedName;
    } else {
      final profile = await AuthService.getUserProfile(email);
      finalName = profile != null && profile['fullName'] is String
          ? (profile['fullName'] as String)
          : email.split('@').first;
    }

    // Set logged-in session
    await AuthService.setCurrentUserEmail(email);

    // Update the repository so Home feed shows the user's real name
    MockRepository.instance.greetingName = finalName;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (r) => false,
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                const AuthBackButton(),
                const SizedBox(height: 32),

                // ── Logo small ────────────────────────────────────────
                const AluLogo(size: 38),
                const SizedBox(height: 28),

                // ── Heading ───────────────────────────────────────────
                const Text('Welcome back 👋',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to your ALU Connect account.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Server error ──────────────────────────────────────
                if (_serverError != null) ...[
                  ErrorBanner(message: _serverError!),
                  const SizedBox(height: 20),
                ],

                // ── Fields ────────────────────────────────────────────
                AuthField(
                  label: 'Email address',
                  hint: 'you@alueducation.com',
                  controller: _emailCtrl,
                  prefixIcon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: _validateEmail,
                ),
                const SizedBox(height: 18),

                AuthField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passCtrl,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _submit(),
                ),

                // ── Forgot ────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                const ForgotPasswordScreen())),
                    child: const Text('Forgot password?'),
                  ),
                ),

                const SizedBox(height: 4),
                GoldButton(
                    label: 'Sign In',
                    onPressed: _submit,
                    isLoading: _loading),

                const SizedBox(height: 28),
                const OrDivider(),
                const SizedBox(height: 20),

                GoogleButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Google Sign-In — coming soon!')),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Sign up link ──────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account?  ",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}