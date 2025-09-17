import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:remind_me/components/home_screen/single_task_row.dart';

import '../../constants/colors.dart';
import '../../entities/task.dart';
import '../../hive/hive_boxes.dart';
import '../../screens/create_task_screen.dart';

class RemindMeList extends StatelessWidget {
  const RemindMeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Task>>(
      valueListenable: Hive.box<Task>(taskBoxKey).listenable(),
      builder: (BuildContext context, Box<Task> box, Widget? _) {
        final tasks = box.values.toList();
        if (tasks.isEmpty) {
          return Expanded(
            child: Center(
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: kPrimaryButtonGradient,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(
                        color: kShadowColor,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hourglass_empty_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                    const Text(
                      'Add Some Tasks First',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kTextSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Create your first reminder to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextLight,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        tasks.sort((a, b) =>
            a.notificationTime.first.compareTo(b.notificationTime.first));
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return FadeInUp(
                duration: Duration(milliseconds: 400 + (index * 100)),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        fullscreenDialog: false,
                        child: CreateTaskScreen(
                          existingTask: task,
                        ),
                      ),
                    );
                  },
                  child: SingleTaskRow(task: task),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
