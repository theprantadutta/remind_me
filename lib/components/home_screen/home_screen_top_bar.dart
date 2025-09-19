import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/colors.dart';
import '../../screens/settings_screen.dart';

class HomeScreenTopBar extends StatelessWidget {
  const HomeScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.06,
        decoration: BoxDecoration(
          gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remind Me',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDarkTheme ? Colors.white : kTextPrimary,
                  letterSpacing: 1.5,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SettingsScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: isDarkTheme ? Colors.white : kTextPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
