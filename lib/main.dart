// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_ce_flutter/hive_flutter.dart';
// import 'package:material_duration_picker/material_duration_picker.dart';
// import 'package:remind_me/hive/hive_registrar.g.dart';
// import 'package:remind_me/services/hive_service.dart';
// import 'package:remind_me/services/notification_service.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:workmanager/workmanager.dart';

// import 'entities/task.dart';
// import 'hive/hive_boxes.dart';
// import 'screens/home_screen.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       await Hive.initFlutter();
//       Hive.registerAdapters();
//       await Hive.openBox<Task>(taskBoxKey);
//       final taskBox = Hive.box<Task>(taskBoxKey);

//       // Collect tasks to update their status
//       final tasksToUpdate = taskBox.keys.where((key) {
//         final task = taskBox.get(key);
//         if (task != null && task.notificationTime.isNotEmpty) {
//           // Check if all notificationTimes are in the past and deleteWhenExpired is true
//           final allNotificationTimesInPast = task.notificationTime
//               .every((dateTime) => dateTime.isBefore(DateTime.now()));

//           return allNotificationTimesInPast && task.deleteWhenExpired;
//         }
//         return false;
//       }).toList();

//       // Update isActive to false for tasks that need to be deleted later
//       for (var key in tasksToUpdate) {
//         final task = taskBox.get(key);
//         if (task != null) {
//           task.isActive = false; // Set task as inactive
//           await taskBox.put(key, task); // Save the updated task
//         }
//       }

//       // Collect keys of tasks to delete after 24 hours
//       final keysToDelete = taskBox.keys.where((key) {
//         final task = taskBox.get(key);
//         return task != null && !task.isActive && !task.deleteWhenExpired;
//       }).toList();

//       // Delete tasks 24 hours later (simulate a 24-hour delay)
//       for (var key in keysToDelete) {
//         await Future.delayed(Duration(hours: 24)); // Simulate 24-hour delay
//         await taskBox.delete(key); // Delete the task after 24 hours
//       }
//       debugPrint('Background task executed successfully');
//       return Future.value(true);
//     } catch (e) {
//       // Handle the error
//       debugPrint('Error occurred in background task: $e');
//       return Future.value(false);
//     }
//   });
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Future.wait([
//     NotificationService.initialize(),
//     HiveService().initialize(),
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: true)
//   ]);
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     Workmanager().registerPeriodicTask(
//       "clean_inactive_tasks", // Unique task identifier
//       "cleanInactiveTasks", // Task name
//       // frequency: Duration(hours: 24),
//       frequency: Duration(minutes: 15),
//       // initialDelay: Duration(minutes: 5),
//       initialDelay: Duration.zero,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       localizationsDelegates: const [
//         DefaultDurationPickerMaterialLocalizations.delegate,
//       ],
//       title: 'Remind Me',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.grey,
//         ),
//         useMaterial3: true,
//         fontFamily: GoogleFonts.nunito().fontFamily,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:remind_me/hive/hive_registrar.g.dart';
import 'package:remind_me/services/hive_service.dart';
import 'package:remind_me/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'entities/task.dart';
import 'hive/hive_boxes.dart';
import 'screens/home_screen.dart';

// Notification channel and ID for foreground service
const notificationChannelId = 'task_service_channel';
const notificationId = 888;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    NotificationService.initialize(),
    HiveService().initialize(),
    initializeService()
  ]);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Create the notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Task Cleaner Service',
    description: 'Handles cleaning inactive tasks.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Task Cleaner Service',
      initialNotificationContent: 'Running background task...',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Ensure proper initialization in the background isolate
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<Task>(taskBoxKey);
  final taskBox = Hive.box<Task>(taskBoxKey);

  service.on("stop").listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 15), (timer) async {
    try {
      // Update tasks logic
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty) {
          final allNotificationTimesInPast = task.notificationTime
              .every((dateTime) => dateTime.isBefore(DateTime.now()));
          return allNotificationTimesInPast && task.deleteWhenExpired;
        }
        return false;
      }).toList();

      for (var key in tasksToUpdate) {
        final task = taskBox.get(key);
        if (task != null) {
          task.isActive = false;
          await taskBox.put(key, task);
        }
      }

      // Delete tasks logic
      final keysToDelete = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        return task != null && !task.isActive && !task.deleteWhenExpired;
      }).toList();

      for (var key in keysToDelete) {
        await taskBox.delete(key);
      }

      notificationsPlugin.show(
        notificationId,
        'Task Cleaner Service',
        'Background task executed successfully at ${DateTime.now()}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'Task Cleaner Service',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in background task: $e');
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        DefaultDurationPickerMaterialLocalizations.delegate,
      ],
      title: 'Remind Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      home: const HomeScreen(),
    );
  }
}
