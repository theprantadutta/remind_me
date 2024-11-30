import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Label
                Expanded(
                  child: ClayText(
                    label,
                    textColor: Colors.grey[700],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                    activeColor: Colors.grey,
                    activeTrackColor: Colors.grey.withOpacity(0.5),
                    inactiveThumbColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[300],
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
