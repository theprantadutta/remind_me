import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../screens/create_task_screen.dart';

class AddNewTaskButton extends StatelessWidget {
  const AddNewTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final containerColor = Colors.grey.shade50.withOpacity(0.1);
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            fullscreenDialog: false,
            child: CreateTaskScreen(),
          ),
        );
      },
      child: ClayContainer(
        color: containerColor,
        borderRadius: 20,
        depth: 10,
        spread: 5,
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.grey.shade200,
            // ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add New Task Text
              ClayText(
                'Add New Task',
                textColor: Colors.grey[700],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              // Add Icon Button
              ClayContainer(
                borderRadius: 50,
                depth: 10,
                color: containerColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
