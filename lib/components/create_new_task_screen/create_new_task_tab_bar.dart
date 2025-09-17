import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_me/entities/task.dart';

import '../../constants/colors.dart';
import '../../hive/hive_boxes.dart';
import '../../services/notification_service.dart';

class CreateNewTaskTabBar extends StatelessWidget {
  final Task? task;

  const CreateNewTaskTabBar({
    super.key,
    this.task,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.07,
        decoration: BoxDecoration(
          gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: isDarkTheme ? Colors.white : kTextPrimary,
                      ),
                    ),
                  ),
                ),
                // Title Text
                Text(
                  task == null ? 'Create New Task' : 'Update Task',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : kTextPrimary,
                  ),
                ),
              ],
            ),
            if (task != null)
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkTheme ? Colors.white : kTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Are you sure you want to delete this task?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkTheme ? kTextLight : kTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (task == null) return;
                                        final taskBox = Hive.box<Task>(taskBoxKey);

                                        // Check if the task is active
                                        if (task!.isActive) {
                                          // Cancel all notifications related to this task
                                          await NotificationService().cancelNotification(task!.id.hashCode);
                                        }

                                        // Delete the task
                                        await taskBox.delete(task!.id);

                                        // Close the dialog and any other page
                                        if (context.mounted) Navigator.pop(context); // Close the dialog
                                        if (context.mounted) Navigator.pop(context); // Close any other page
                                      },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0x1FEF4444), // kErrorColor with 0.1 alpha
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: kErrorColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: isDarkTheme ? Colors.white : kTextPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
