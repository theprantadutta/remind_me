import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

// class HomeScreenTopBar extends StatelessWidget {
//   const HomeScreenTopBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClayContainer(
//       height: MediaQuery.sizeOf(context).height * 0.06,
//       borderRadius: 20,
//       depth: 10,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 3,
//           horizontal: 10,
//         ),
//         child: Row(
//           children: [
//             ClayText(
//               'Remind Me',
//               textColor: Colors.grey[400],
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeScreenTopBar extends StatelessWidget {
  const HomeScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final containerColor = Colors.grey.shade50.withOpacity(0.1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ClayContainer(
        height: MediaQuery.sizeOf(context).height * 0.06,
        borderRadius: 20,
        depth: 10,
        spread: 5,
        color: containerColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClayText(
                'Remind Me',
                textColor: Colors.grey[700],
                emboss: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
