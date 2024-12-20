import 'package:flutter/material.dart';
import 'package:remind_me/components/create_new_task_screen/add_new_task_button.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 20,
      right: 10,
      child: AddNewTaskButton(),
    );
  }
}
