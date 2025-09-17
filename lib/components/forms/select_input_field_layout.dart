import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SelectInputFieldLayout extends StatelessWidget {
  final int index;
  final String label;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const SelectInputFieldLayout({
    super.key,
    required this.index,
    required this.label,
    required this.selectedValue,
    required this.options,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
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
                // Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        isExpanded: true,
                        items: options.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkTheme ? Colors.white : kTextPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onChanged,
                        dropdownColor: isDarkTheme ? kDarkCardGradient.colors.first : kCardGradient.colors.first,
                        borderRadius: BorderRadius.circular(12),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: isDarkTheme ? Colors.white.withValues(alpha: 0.7) : kTextSecondary,
                        ),
                      ),
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
