// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_widgets.dart';
import 'login_screen.dart';
import 'role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _agreed = false;

  // Academic details
  bool _isAlumni = false;
  String? _selectedIntakeMonth;
  String? _selectedIntakeYear;
  String? _selectedGraduationYear;
  String? _selectedFaculty;

  // ── Validation ──────────────────────────────────────────
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (v.trim().split(' ').length < 2) return 'Enter your first and last name';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ── Submit ───────────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please accept the Terms & Privacy Policy.')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _loading = false);

    // Navigate to role selection, passing entered name & academic details
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RoleSelectionScreen(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        isAlumni: _isAlumni,
        intakeMonth: _isAlumni ? null : _selectedIntakeMonth,
        intakeYear: _isAlumni ? null : _selectedIntakeYear,
        graduationYear: _isAlumni ? _selectedGraduationYear : null,
        faculty: _selectedFaculty,
      ),
    ));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Password strength bar ────────────────────────────────
  double _passStrength(String p) {
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[0-9]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(p)) s += 0.25;
    return s;
  }

  Color _strengthColor(double s) {
    if (s <= 0.25) return AppColors.danger;
    if (s <= 0.50) return Colors.orange;
    if (s <= 0.75) return AppColors.gold;
    return AppColors.gold;
  }

  String _strengthLabel(double s) {
    if (s <= 0.25) return 'Weak';
    if (s <= 0.50) return 'Fair';
    if (s <= 0.75) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    final pass = _passCtrl.text;
    final strength = _passStrength(pass);

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
                const AluLogo(size: 38),
                const SizedBox(height: 28),

                const Text(
                  'Create your\naccount',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Join the ALU Connect community today.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Full name ────────────────────────────────────────
                AuthField(
                  label: 'Full name',
                  hint: 'e.g. Kwame Mensah',
                  controller: _nameCtrl,
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: 18),

                // ── Email ────────────────────────────────────────────
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

                // ── Password ─────────────────────────────────────────
                AuthField(
                  label: 'Password',
                  hint: 'Min 8 chars, uppercase & number',
                  controller: _passCtrl,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: _validatePass,
                  onFieldSubmitted: (_) {},
                ),

                // Strength bar (shown when typing)
                if (pass.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: strength,
                          minHeight: 4,
                          backgroundColor: AppColors.surfaceAlt,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _strengthColor(strength)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _strengthLabel(strength),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _strengthColor(strength),
                      ),
                    ),
                  ]),
                ],

                const SizedBox(height: 18),

                // ── Confirm password ─────────────────────────────────
                StatefulBuilder(builder: (ctx, ss) {
                  return AuthField(
                    label: 'Confirm password',
                    hint: 'Re-enter your password',
                    controller: _confirmCtrl,
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: _validateConfirm,
                    onFieldSubmitted: (_) {},
                  );
                }),

                // ── Academic Status Question ─────────────────────────
                const SizedBox(height: 18),
                const Text(
                  'Are you an ALU Student or ALU Alumni?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isAlumni = false;
                          _selectedGraduationYear = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isAlumni
                                ? AppColors.gold.withOpacity(0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: !_isAlumni ? AppColors.gold : AppColors.border,
                              width: !_isAlumni ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: const [
                              SizedBox(height: 4),
                              Text(
                                'ALU Student',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isAlumni = true;
                          _selectedIntakeMonth = null;
                          _selectedIntakeYear = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isAlumni
                                ? AppColors.gold.withOpacity(0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isAlumni ? AppColors.gold : AppColors.border,
                              width: _isAlumni ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: const [
                              SizedBox(height: 4),
                              Text(
                                'ALU Alumni',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Conditional Fields ──────────────────────────────
                if (!_isAlumni) ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      // Intake Month Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Intake Month',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 7),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedIntakeMonth,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Month',
                                prefixIcon: Icon(Icons.calendar_month_rounded,
                                    color: AppColors.textSecondary, size: 18),
                              ),
                              items: ['January', 'May', 'September'].map((m) {
                                return DropdownMenuItem(value: m, child: Text(m));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedIntakeMonth = val),
                              validator: (val) =>
                                  val == null ? 'Month required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Intake Year Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Intake Year',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 7),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedIntakeYear,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Year',
                                prefixIcon: Icon(Icons.date_range_rounded,
                                    color: AppColors.textSecondary, size: 18),
                              ),
                              items: ['2020', '2021', '2022', '2023', '2024',
                                      '2025', '2026'].map((y) {
                                return DropdownMenuItem(value: y, child: Text(y));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedIntakeYear = val),
                              validator: (val) =>
                                  val == null ? 'Year required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Faculty Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Faculty',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 7),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _selectedFaculty,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Select Faculty',
                          prefixIcon: Icon(Icons.school_rounded,
                              color: AppColors.textSecondary, size: 18),
                        ),
                        items: [
                          ('BSE', 'BSE (Software Engineering)'),
                          ('BEL', 'BEL (Entrepreneurial Leadership)'),
                          ('IBT', 'IBT (International Business & Trade)'),
                        ].map((item) {
                          return DropdownMenuItem(
                              value: item.$1, child: Text(item.$2));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedFaculty = val),
                        validator: (val) =>
                            val == null ? 'Faculty required' : null,
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      // Graduation Year Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Graduation Year',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 7),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedGraduationYear,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Year',
                                prefixIcon: Icon(Icons.workspace_premium_rounded,
                                    color: AppColors.textSecondary, size: 18),
                              ),
                              items: ['2018', '2019', '2020', '2021', '2022',
                                      '2023', '2024', '2025', '2026'].map((y) {
                                return DropdownMenuItem(value: y, child: Text(y));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedGraduationYear = val),
                              validator: (val) =>
                                  val == null ? 'Year required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Faculty Graduated In
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Faculty Graduated In',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 7),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedFaculty,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Select Faculty',
                                prefixIcon: Icon(Icons.school_rounded,
                                    color: AppColors.textSecondary, size: 18),
                              ),
                              items: [
                                ('BSE', 'BSE (Software Eng.)'),
                                ('BEL', 'BEL (Leadership)'),
                                ('IBT', 'IBT (Business/Trade)'),
                              ].map((item) {
                                return DropdownMenuItem(
                                    value: item.$1, child: Text(item.$2));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedFaculty = val),
                              validator: (val) =>
                                  val == null ? 'Faculty required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // ── Terms checkbox ───────────────────────────────────
                GestureDetector(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _agreed
                              ? AppColors.gold
                              : Colors.transparent,
                          border: Border.all(
                            color: _agreed
                                ? AppColors.gold
                                : AppColors.border,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _agreed
                            ? const Icon(Icons.check_rounded,
                                size: 13, color: AppColors.background)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                GoldButton(
                    label: 'Continue',
                    onPressed: _submit,
                    isLoading: _loading,
                    icon: Icons.arrow_forward_rounded),

                const SizedBox(height: 28),
                const OrDivider(),
                const SizedBox(height: 20),

                GoogleButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Google Sign-Up — coming soon!')),
                        )),

                const SizedBox(height: 36),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account?  ',
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
          ),
        ),
      ),
    );
  }
}