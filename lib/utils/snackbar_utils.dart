import 'package:flutter/material.dart';

import '../constants/colors.dart';

class SnackbarUtils {
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      kSuccessColor,
      Icons.check_circle_outline,
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      kErrorColor,
      Icons.error_outline,
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      kWarningColor,
      Icons.warning_amber_outlined,
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      kPrimaryColor,
      Icons.info_outline,
    );
  }

  static void _showCustomSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final snackBar = SnackBar(
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.8),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}