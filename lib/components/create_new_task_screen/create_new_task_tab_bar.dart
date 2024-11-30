import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_me/entities/task.dart';

import '../../hive/hive_boxes.dart';

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
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        // content: Text('Are you sure want to delete this task?'),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        content: Builder(
                          builder: (context) {
                            return Container(
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Are you sure you want to delete this task?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          final taskBox =
                                              Hive.box<Task>(taskBoxKey);
                                          await taskBox.delete(task!.id);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
