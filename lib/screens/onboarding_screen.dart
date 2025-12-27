import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';
import '../navigation/app_shell.dart';

/// Onboarding screen shown to first-time users
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String hasSeenOnboardingKey = 'hasSeenOnboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.task_alt_rounded,
      title: 'Welcome to Remind Me',
      description:
          'Your personal task manager to help you stay organized and never miss important deadlines.',
    ),
    _OnboardingPage(
      icon: Icons.notifications_active_rounded,
      title: 'Smart Reminders',
      description:
          'Set multiple reminders for each task. Get notified at the right time, every time.',
    ),
    _OnboardingPage(
      icon: Icons.category_rounded,
      title: 'Organize with Categories',
      description:
          'Group your tasks by categories and priorities. Find what you need instantly.',
    ),
    _OnboardingPage(
      icon: Icons.calendar_month_rounded,
      title: 'Calendar View',
      description:
          'See all your tasks in a beautiful calendar. Plan your days and weeks with ease.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(OnboardingScreen.hasSeenOnboardingKey, true);
    } catch (e) {
      debugPrint('Failed to save onboarding state: $e');
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppShell()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: AppEdgeInsets.md,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            // Page indicators
            Padding(
              padding: AppEdgeInsets.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? colorScheme.primary
                          : colorScheme.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Navigation button
            Padding(
              padding: AppEdgeInsets.lg,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  style: FilledButton.styleFrom(
                    padding: AppEdgeInsets.md,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: AppTypography.labelLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppEdgeInsets.xl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: colorScheme.primary,
            ),
          ),
          AppGaps.xxl,
          Text(
            page.title,
            style: AppTypography.headlineMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AppGaps.lg,
          Text(
            page.description,
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
