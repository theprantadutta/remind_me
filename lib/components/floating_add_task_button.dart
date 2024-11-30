import 'package:flutter/material.dart';
import 'package:remind_me/components/add_new_task_button.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 10,
      child: AddNewTaskButton(),
    );
  }
}
