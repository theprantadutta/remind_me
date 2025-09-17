import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class InputFieldSwitchLayout extends StatelessWidget {
  final int index;
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const InputFieldSwitchLayout({
    super.key,
    required this.index,
    required this.label,
    required this.value,
    required this.onChanged,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Label
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkTheme ? Colors.white : kTextPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                // Switch
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: value,
                    onChanged: onChanged,
                    activeThumbColor: kPrimaryColor,
                    activeTrackColor: kPrimaryColor.withValues(alpha: 0.3),
                    inactiveThumbColor: isDarkTheme ? Colors.grey[600] : Colors.grey[400],
                    inactiveTrackColor: isDarkTheme ? Colors.grey[700] : Colors.grey[300],
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
