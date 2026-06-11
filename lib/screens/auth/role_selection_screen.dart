// lib/screens/auth/role_selection_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_widgets.dart';
import '../main_shell.dart';
import '../../services/auth_service.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({
    super.key,
    required this.name,
    required this.email,
    required this.isAlumni,
    this.intakeMonth,
    this.intakeYear,
    this.graduationYear,
    this.faculty,
  });

  final String name;
  final String email;
  final bool isAlumni;
  final String? intakeMonth;
  final String? intakeYear;
  final String? graduationYear;
  final String? faculty;

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selected;
  bool _loading = false;

  Future<void> _confirm() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose your role to continue.')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Save user profile details to SharedPreferences
    await AuthService.saveUserProfile(
      email: widget.email,
      fullName: widget.name,
      role: _selected == UserRole.student ? 'student' : 'organizer',
      isAlumni: widget.isAlumni,
      intakeMonth: widget.intakeMonth,
      intakeYear: widget.intakeYear,
      graduationYear: widget.graduationYear,
      faculty: widget.faculty,
    );

    // Mark user as logged in
    await AuthService.setCurrentUserEmail(widget.email);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.name.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const AuthBackButton(),
              const SizedBox(height: 40),

              // ── Greeting ─────────────────────────────────────────
              RichText(
                text: TextSpan(
                  text: 'Hey $firstName,\n',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                  children: const [
                    TextSpan(
                      text: 'who are you?',
                      style: TextStyle(color: AppColors.gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your role on ALU Connect. You can update this later in settings.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 36),

              // ── Role cards ───────────────────────────────────────
              _RoleCard(
                role: UserRole.student,
                selected: _selected == UserRole.student,
                onTap: () => setState(() => _selected = UserRole.student),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                role: UserRole.organizer,
                selected: _selected == UserRole.organizer,
                onTap: () => setState(() => _selected = UserRole.organizer),
              ),

              const SizedBox(height: 16),

              // ── Info card ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.gold.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.gold.withOpacity(0.8), size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Organizers need approval from ALU administration before posting.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              GoldButton(
                label: 'Get Started',
                onPressed: _confirm,
                isLoading: _loading,
                icon: Icons.rocket_launch_rounded,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Role card widget
// ─────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final features = role == UserRole.student
        ? [
            'Discover events, hackathons & internships',
            'RSVP and track your participation',
            'Join clubs and community hubs',
            'Earn achievement badges & impact score',
            'Chat within event communities',
          ]
        : [
            'Post events, workshops & announcements',
            'Manage RSVPs and attendance',
            'Create and lead community hubs',
            'Broadcast to the entire ALU network',
            'Access analytics and engagement stats',
          ];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold.withOpacity(0.07)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.10),
                    blurRadius: 24,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji in circle
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.gold.withOpacity(0.15)
                        : AppColors.surfaceAlt,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.gold.withOpacity(0.40)
                          : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(role.icon,
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? AppColors.gold
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selected indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.gold : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: AppColors.background)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 14),

            // Feature list
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: selected
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}