import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:material_duration_picker/material_duration_picker.dart';

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
      durationPickerMode: DurationPickerMode.hms,
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
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}h : '
        '${minutes.toString().padLeft(2, '0')}m : '
        '${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final containerColor = Colors.grey.shade50.withOpacity(0.1);

    return FadeInUp(
      duration: Duration(milliseconds: widget.index * 150),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ClayContainer(
          width: double.infinity,
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
                  widget.label,
                  textColor: Colors.grey[700],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                // Duration Input Field
                ClayContainer(
                  borderRadius: 10,
                  depth: -5,
                  color: containerColor,
                  child: InkWell(
                    onTap: _showDurationPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
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
                                      ? Colors.white.withOpacity(0.6)
                                      : Colors.black.withOpacity(0.5)
                                  : isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
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
