import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';

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
    final containerColor = Colors.grey.shade50.withOpacity(0.1);

    return FadeInUp(
      duration: Duration(milliseconds: index * 150),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ClayContainer(
          color: containerColor,
          borderRadius: 20,
          depth: 10,
          spread: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label Text
                ClayText(
                  label,
                  textColor: Colors.grey[700],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                // Date and Time Row
                ClayContainer(
                  borderRadius: 10,
                  depth: -5,
                  color: containerColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display Selected Date and Time
                        ClayText(
                          selectedDateTime,
                          textColor: Colors.grey,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        // Change Button
                        GestureDetector(
                          onTap: onChange,
                          child: ClayContainer(
                            borderRadius: 10,
                            depth: 10,
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: ClayText(
                                "Change",
                                textColor: Colors.grey,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
