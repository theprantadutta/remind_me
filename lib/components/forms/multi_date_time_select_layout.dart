import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final containerColor = Colors.grey.shade50.withOpacity(0.1);

    return FadeInUp(
      duration: Duration(milliseconds: widget.index * 150),
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
              children: [
                // Label Text
                ClayText(
                  widget.label,
                  textColor: Colors.grey[700],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display Selected Date-Time
                        Expanded(
                          child: ClayText(
                            DateFormat.yMEd().add_jms().format(dateTime),
                            textColor: Colors.grey,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        // Remove Button
                        GestureDetector(
                          onTap: () => widget.onRemoveDateTime(index),
                          child: ClayContainer(
                            borderRadius: 10,
                            depth: 10,
                            // color: Colors.red.shade200,
                            color: Colors.grey.shade400,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ClayText(
                                "Remove",
                                textColor: Colors.white,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                // Add New Date-Time Button
                GestureDetector(
                  onTap: widget.onAddDateTime,
                  child: ClayContainer(
                    borderRadius: 10,
                    depth: 10,
                    color: Colors.grey.shade200,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Center(
                        child: ClayText(
                          "Add Date-Time",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
