// lib/screens/auth/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_widgets.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

// ─────────────────────────────────────────────
//  Page data
// ─────────────────────────────────────────────
class _Page {
  const _Page(
      {required this.emoji,
      required this.title,
      required this.body,
      required this.accent});
  final String emoji;
  final String title;
  final String body;
  final Color accent;
}

const _pages = [
  _Page(
    emoji: '',
    title: 'Discover\nOpportunities',
    body:
        'Hackathons, internships, workshops, leadership programs — everything happening at ALU, in one feed.',
    accent: AppColors.gold,
  ),
  _Page(
    emoji: '',
    title: 'Join Clubs &\nCommunities',
    body:
        'Connect with Founders Circle, Tech Ventures, debate clubs and more. RSVP and track what matters to you.',
    accent: Color(0xFF4B9FFF),
  ),
  _Page(
    emoji: '',
    title: 'Chat &\nCollaborate',
    body:
        'Message event communities, follow trending discussions, and build your ALU impact score along the way.',
    accent: AppColors.gold,
  ),
];

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _idx = 0;

  void _next() {
    if (_idx < _pages.length - 1) {
      _pc.nextPage(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOutCubic);
    }
  }

  void _skip() => _pc.animateToPage(_pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic);

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _idx == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AluLogo(size: 36),
                  if (!isLast)
                    TextButton(
                      onPressed: _skip,
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pc,
                onPageChanged: (i) => setState(() => _idx = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageView(page: _pages[i]),
              ),
            ),

            // Dots
            _Dots(count: _pages.length, current: _idx),
            const SizedBox(height: 28),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLast
                  ? Column(children: [
                      GoldButton(
                          label: 'Create Account',
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()))),
                      const SizedBox(height: 12),
                      OutlinedGoldButton(
                          label: 'Sign In',
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()))),
                    ])
                  : GoldButton(label: 'Next', onPressed: _next),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Single page
// ─────────────────────────────────────────────
class _PageView extends StatelessWidget {
  const _PageView({required this.page});
  final _Page page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing emoji circle
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.accent.withOpacity(0.08),
              border: Border.all(
                  color: page.accent.withOpacity(0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: page.accent.withOpacity(0.14),
                  blurRadius: 48,
                  spreadRadius: 8,
                )
              ],
            ),
            child: Center(
                child: Text(page.emoji,
                    style: const TextStyle(fontSize: 54))),
          ),
          const SizedBox(height: 44),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Dot indicators
// ─────────────────────────────────────────────
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.gold : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}