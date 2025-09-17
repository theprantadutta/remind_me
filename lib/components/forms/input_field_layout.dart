import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class InputFieldLayout extends StatelessWidget {
  final TextEditingController textEditingController;
  final int index;
  final String label;
  final String hintText;
  final int maxLines;
  final TextInputType? textInputType;

  const InputFieldLayout({
    super.key,
    required this.textEditingController,
    required this.index,
    required this.label,
    this.maxLines = 1,
    required this.hintText,
    this.textInputType,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: textEditingController,
                    keyboardType: textInputType ?? TextInputType.text,
                    maxLines: maxLines,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkTheme ? Colors.white.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
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
