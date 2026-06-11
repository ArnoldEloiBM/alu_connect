// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_widgets.dart';
import '../main_shell.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../services/auth_service.dart';
import '../../data/mock_repository.dart';
import '../../services/user_session.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<bool> onDarkModeToggle;

  const LoginScreen({super.key, required this.onDarkModeToggle});

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
  String? _validateEmail(String? v) => AuthService.validateAluStudentEmail(v);

  String? _validatePassword(String? v) => AuthService.validateStrongPassword(v);

  // ── Submit ───────────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _serverError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final email = _emailCtrl.text.trim().toLowerCase();
    final password = _passCtrl.text;

    final approved = await AuthService.signIn(email: email, password: password);
    if (!mounted) return;
    setState(() => _loading = false);

    if (!approved) {
      setState(() {
        _serverError =
            'Invalid email or password. Use ${AuthService.demoEmail} / ${AuthService.demoPassword} for the demo account, or sign up first.';
      });
      return;
    }

    final profile = await AuthService.getUserProfile(email);
    final finalName = profile != null && profile['fullName'] is String
        ? (profile['fullName'] as String)
        : email.split('@').first;

    await AuthService.setCurrentUserEmail(email);
    await UserSession.instance.setDisplayName(finalName);
    MockRepository.instance.greetingName = finalName;

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainShell(onDarkModeToggle: widget.onDarkModeToggle),
      ),
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
                const SizedBox(height: 10),
                Text(
                  'Demo: ${AuthService.demoEmail} / ${AuthService.demoPassword}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.gold,
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
                  hint: AuthService.emailHint,
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
                            builder: (_) => ForgotPasswordScreen(
                                  onDarkModeToggle: widget.onDarkModeToggle,
                                ))),
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
                            builder: (_) => SignUpScreen(
                                  onDarkModeToggle: widget.onDarkModeToggle,
                                ))),
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