import 'package:animate_do/animate_do.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';

class InputFieldLayout extends StatelessWidget {
  final TextEditingController textEditingController;
  final int index;
  final String label;
  final String hintText;
  final int maxLines;

  const InputFieldLayout({
    super.key,
    required this.textEditingController,
    required this.index,
    required this.label,
    this.maxLines = 1,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // final containerColor = Theme.of(context).scaffoldBackgroundColor;
    final containerColor = Colors.grey.shade50.withOpacity(0.1);

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.1),
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(15),
    );

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
                // Input Field
                ClayContainer(
                  borderRadius: 10,
                  depth: -5,
                  color: containerColor,
                  child: TextField(
                    controller: textEditingController,
                    maxLines: maxLines,
                    // onChanged: (value) {
                    //   inputController.text = value;
                    // },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkTheme
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
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
