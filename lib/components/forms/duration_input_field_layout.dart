import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:material_duration_picker/material_duration_picker.dart';

import '../../constants/colors.dart';

class DurationInputFieldLayout extends StatefulWidget {
  final int index;
  final String label;
  final String hintText;
  final int initialValue;
  final void Function(int seconds) onChange;

  const DurationInputFieldLayout({
    super.key,
    required this.index,
    required this.label,
    required this.hintText,
    this.initialValue = 0,
    required this.onChange,
  });

  @override
  State<DurationInputFieldLayout> createState() => _DurationInputFieldState();
}

class _DurationInputFieldState extends State<DurationInputFieldLayout> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedDuration with the provided initialValue
    _selectedDuration = Duration(seconds: widget.initialValue);
  }

  Future<void> _showDurationPicker() async {
    final pickedDuration = await showDurationPicker(
      context: context,
      initialDuration: _selectedDuration,
      durationPickerMode: DurationPickerMode.hm,
      // initialEntryMode: DurationPickerEntryMode.inputOnly,
    );

    if (pickedDuration != null) {
      setState(() {
        _selectedDuration = pickedDuration;
        // Notify parent about the change
        widget.onChange(pickedDuration.inSeconds);
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    // final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}h : '
        '${minutes.toString().padLeft(2, '0')}m';
    // '${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: Duration(milliseconds: widget.index * 150),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: double.infinity,
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
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : kTextPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Duration Input Field
                InkWell(
                  onTap: _showDurationPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDuration == const Duration()
                              ? widget.hintText
                              : _formatDuration(_selectedDuration),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedDuration == const Duration()
                                ? isDarkTheme
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.5)
                                : isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: isDarkTheme ? Colors.white.withValues(alpha: 0.7) : kTextSecondary,
                          size: 20,
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
