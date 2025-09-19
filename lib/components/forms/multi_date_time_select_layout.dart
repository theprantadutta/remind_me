import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';

class MultiDateTimeSelectLayout extends StatefulWidget {
  final int index;
  final String label;
  final List<DateTime> selectedDates;
  final VoidCallback onAddDateTime;
  final Function(int index) onRemoveDateTime;

  const MultiDateTimeSelectLayout({
    super.key,
    required this.index,
    required this.label,
    required this.selectedDates,
    required this.onAddDateTime,
    required this.onRemoveDateTime,
  });

  @override
  State<MultiDateTimeSelectLayout> createState() => _MultiDateTimeSelectState();
}

class _MultiDateTimeSelectState extends State<MultiDateTimeSelectLayout> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: Duration(milliseconds: widget.index * 150),
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
                // Label Text
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : kTextPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                // List of Selected Date-Times
                ...widget.selectedDates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final dateTime = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Display Selected Date-Time
                          Expanded(
                            child: Text(
                              DateFormat.yMEd().add_jms().format(dateTime),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkTheme ? Colors.white : kTextSecondary,
                              ),
                            ),
                          ),
                          // Remove Button
                          GestureDetector(
                            onTap: () => widget.onRemoveDateTime(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kErrorColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kErrorColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                // Add New Date-Time Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: widget.onAddDateTime,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDarkTheme ? Colors.white70 : kPrimaryColor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Add Date-Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkTheme ? Colors.white : kPrimaryColor,
                        letterSpacing: 1.2,
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
