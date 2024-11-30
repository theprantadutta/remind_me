import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';

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
              children: [
                // Label
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
                // Dropdown
                ClayContainer(
                  borderRadius: 10,
                  depth: -5,
                  color: containerColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        isExpanded: true,
                        items: options.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: ClayText(
                              option,
                              textColor: Colors.grey[700],
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: onChanged,
                        dropdownColor: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
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
