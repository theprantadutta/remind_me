import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:remind_me/constants/colors.dart';
import 'package:remind_me/entities/task.dart';
import 'package:remind_me/hive/hive_boxes.dart';

class AlarmScreen extends StatefulWidget {
  final String? taskId;
  final String? title;
  final String? body;

  const AlarmScreen({
    super.key,
    this.taskId,
    this.title,
    this.body,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Task? _task;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() {
    if (widget.taskId != null) {
      final taskBox = Hive.box<Task>(taskBoxKey);
      _task = taskBox.get(widget.taskId);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current theme to adapt colors
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Create subtle gradient background
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // Base colors with very low opacity for subtle effect
        (isDarkMode ? kPrimaryColor : kSecondaryColor).withValues(alpha: 0.08),
        (isDarkMode ? kSecondaryColor : kPrimaryColor).withValues(alpha: 0.05),
        (isDarkMode ? kPrimaryColor : kSecondaryColor).withValues(alpha: 0.03),
      ],
    );

    // Text colors that work on both themes
    final primaryTextColor = isDarkMode ? Colors.white : kTextPrimary;
    final secondaryTextColor = isDarkMode ? Colors.white70 : kTextSecondary;
    final accentColor = isDarkMode ? kPrimaryColor : kSecondaryColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Alarm icon - using app's primary colors
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      gradient:
                          kPrimaryButtonGradient, // Using app's primary gradient
                      borderRadius: BorderRadius.circular(75),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    _task?.title ?? widget.title ?? 'ALARM',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: (isDarkMode ? Colors.black : Colors.white)
                              .withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    _task?.description ?? widget.body ?? 'Time to wake up!',
                    style: TextStyle(
                      fontSize: 20,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),

                  // Time display with proper 12-hour format
                  if (_task != null && _task!.notificationTime.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: (isDarkMode ? Colors.white : kPrimaryColor)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        DateFormat.jm().format(_task!.notificationTime
                            .first), // 12-hour format with AM/PM
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontFamily: 'monospace',
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: (isDarkMode ? Colors.black : Colors.white)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 60),

                  // Dismiss button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: isDarkMode
                          ? kPrimaryButtonGradient
                          : const LinearGradient(
                              colors: [Colors.white, Color(0xFFF8F9FA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: (isDarkMode ? kPrimaryColor : Colors.white)
                              .withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            isDarkMode ? Colors.white : Colors.black87,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text(
                        'DISMISS ALARM',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Snooze button
                  TextButton(
                    onPressed: () {
                      // Add snooze functionality here if needed
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: secondaryTextColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    child: const Text(
                      'Snooze 5 min',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
