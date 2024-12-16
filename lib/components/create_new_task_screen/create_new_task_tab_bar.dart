import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_me/entities/task.dart';

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
    final containerColor = Colors.grey.shade50.withOpacity(0.1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClayContainer(
        height: MediaQuery.sizeOf(context).height * 0.07,
        borderRadius: 20,
        color: containerColor,
        depth: 10,
        spread: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClayContainer(
                    color: containerColor,
                    borderRadius: 50,
                    depth: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                // Title Text
                ClayText(
                  task == null ? 'Create New Task' : 'Update Task',
                  textColor: Colors.grey[700],
                  emboss: true,
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
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
                        child: ClayContainer(
                          depth: 0,
                          spread: 2,
                          borderRadius: 20,
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClayText(
                                  'Are you sure?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textColor: Colors.black.withOpacity(0.7),
                                ),
                                const SizedBox(height: 16),
                                ClayText(
                                  'Are you sure you want to delete this task?',
                                  textColor: Colors.grey,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: ClayContainer(
                                        depth: 10,
                                        borderRadius: 10,
                                        color: Colors.grey.shade50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
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
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     final taskBox =
                                    //         Hive.box<Task>(taskBoxKey);
                                    //     await taskBox.delete(task!.id);
                                    //     Navigator.pop(
                                    //         context); // Close the dialog
                                    //     Navigator.pop(
                                    //         context); // Close any other page
                                    //   },
                                    //   child: ClayContainer(
                                    //     depth: 10,
                                    //     borderRadius: 10,
                                    //     color: Colors.grey.shade50,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 20, vertical: 8),
                                    //       child: Text(
                                    //         'Delete',
                                    //         style: TextStyle(
                                    //           color: Colors.redAccent,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (task == null) return;
                                        final taskBox =
                                            Hive.box<Task>(taskBoxKey);

                                        // Check if the task is active
                                        if (task!.isActive) {
                                          // Cancel all notifications related to this task
                                          await NotificationService()
                                              .cancelNotification(
                                                  task!.id.hashCode);
                                        }

                                        // Delete the task
                                        await taskBox.delete(task!.id);

                                        // Close the dialog and any other page
                                        Navigator.pop(
                                            context); // Close the dialog
                                        Navigator.pop(
                                            context); // Close any other page
                                      },
                                      child: ClayContainer(
                                        depth: 10,
                                        borderRadius: 10,
                                        color: Colors.grey.shade50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.redAccent,
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
