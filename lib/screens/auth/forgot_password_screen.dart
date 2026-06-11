// lib/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_widgets.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final ValueChanged<bool> onDarkModeToggle;

  const ForgotPasswordScreen({super.key, required this.onDarkModeToggle});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _sent
              ? _SentView(
                  email: _emailCtrl.text.trim(),
                  onDarkModeToggle: widget.onDarkModeToggle,
                )
              : _FormView(
                  formKey: _formKey,
                  emailCtrl: _emailCtrl,
                  loading: _loading,
                  onValidateEmail: _validateEmail,
                  onSubmit: _submit,
                  onDarkModeToggle: widget.onDarkModeToggle,
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Step 1 – Enter email
// ─────────────────────────────────────────────
class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.loading,
    required this.onValidateEmail,
    required this.onSubmit,
    required this.onDarkModeToggle,
  });

  final ValueChanged<bool> onDarkModeToggle;

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool loading;
  final String? Function(String?) onValidateEmail;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const AuthBackButton(),
          const SizedBox(height: 40),

          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.gold.withOpacity(0.30), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.lock_reset_rounded,
                  color: AppColors.gold, size: 32),
            ),
          ),

          const SizedBox(height: 28),
          const Text(
            'Forgot your\npassword?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'No worries! Enter your email and we\'ll send you a reset link.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 36),

          AuthField(
            label: 'Email address',
            hint: AuthService.emailHint,
            controller: emailCtrl,
            prefixIcon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: onValidateEmail,
            onFieldSubmitted: (_) => onSubmit(),
          ),

          const SizedBox(height: 28),

          GoldButton(
            label: 'Send Reset Link',
            onPressed: onSubmit,
            isLoading: loading,
            icon: Icons.send_rounded,
          ),

          const SizedBox(height: 36),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => LoginScreen(
                            onDarkModeToggle: onDarkModeToggle,
                          ))),
              child: RichText(
                text: const TextSpan(
                  text: 'Back to  ',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Step 2 – Sent confirmation
// ─────────────────────────────────────────────
class _SentView extends StatelessWidget {
  const _SentView({
    required this.email,
    required this.onDarkModeToggle,
  });

  final String email;
  final ValueChanged<bool> onDarkModeToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 80),

        // Checkmark circle
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.10),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.gold.withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(0.12),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.mark_email_read_rounded,
                color: AppColors.gold, size: 44),
          ),
        ),

        const SizedBox(height: 32),
        const Text(
          'Check your email',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'We sent a password reset link to\n',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            children: [
              TextSpan(
                text: email,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GoldButton(
            label: 'Back to Sign In',
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  onDarkModeToggle: onDarkModeToggle,
                ),
              ),
              (r) => false,
            ),
          ),
        ),

        const SizedBox(height: 24),

        TextButton(
          onPressed: () {},
          child: const Text(
            "Didn't receive it? Resend",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}