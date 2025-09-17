import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DateTimeSelectLayout extends StatelessWidget {
  final int index;
  final String label;
  final String selectedDateTime;
  final VoidCallback onChange;

  const DateTimeSelectLayout({
    super.key,
    required this.index,
    required this.label,
    required this.selectedDateTime,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: Duration(milliseconds: index * 150),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: kShadowColor,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label Text
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : kTextPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Date and Time Row
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display Selected Date and Time
                        Text(
                          selectedDateTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkTheme ? Colors.white : kTextSecondary,
                          ),
                        ),
                        // Change Button
                        GestureDetector(
                          onTap: onChange,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: kSecondaryButtonGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
