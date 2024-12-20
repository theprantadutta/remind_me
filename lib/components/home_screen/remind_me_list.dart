import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:remind_me/components/home_screen/single_task_row.dart';

import '../../entities/task.dart';
import '../../hive/hive_boxes.dart';
import '../../screens/create_task_screen.dart';

// class RemindMeList extends StatelessWidget {
//   const RemindMeList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tasks = Hive.box<Task>(taskBoxKey).values;
//     if (tasks.isEmpty) {
//       return Expanded(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ClayText(
//                 'Add Some Tasks First',
//                 color: Colors.grey[500],
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//               SizedBox(height: 5),
//               AddNewTaskButton(),
//             ],
//           ),
//         ),
//       );
//     }
//     return Expanded(
//       child: ListView.builder(
//         itemCount: tasks.length,
//         itemBuilder: (context, index) {
//           final task = tasks.toList()[index];
//           return GestureDetector(
//             onTap: () async {
//               await Navigator.push(
//                 context,
//                 PageTransition(
//                   type: PageTransitionType.fade,
//                   fullscreenDialog: false,
//                   child: CreateTaskScreen(
//                     existingTask: task,
//                   ),
//                 ),
//               );
//             },
//             child: SingleTaskRow(task: task),
//           );
//         },
//       ),
//     );
//   }
// }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClayContainer(
                    height: 80,
                    width: 80,
                    customBorderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      Icons.hourglass_empty_outlined,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClayText(
                    'Add Some Tasks First',
                    color: Colors.grey[500],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  // const AddNewTaskButton(),
                ],
              ),
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
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
              );
            },
          ),
        );
      },
    );
  }
}
