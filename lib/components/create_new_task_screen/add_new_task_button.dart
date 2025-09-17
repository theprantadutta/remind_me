import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/colors.dart';
import '../../screens/create_task_screen.dart';

class AddNewTaskButton extends StatelessWidget {
  const AddNewTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BounceInUp(
      duration: const Duration(milliseconds: 800),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              fullscreenDialog: false,
              child: const CreateTaskScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: kPrimaryButtonGradient,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D6366F1), // kPrimaryColor with 0.3 alpha
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: kShadowColorDark,
                blurRadius: 25,
                offset: Offset(0, 15),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 24,
                    color: Colors.white,
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
