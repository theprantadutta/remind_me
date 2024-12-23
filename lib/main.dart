import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:remind_me/hive/hive_registrar.g.dart';
import 'package:remind_me/services/hive_service.dart';
import 'package:remind_me/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'entities/task.dart';
import 'hive/hive_boxes.dart';
import 'screens/home_screen.dart';

const notificationChannelId = 'task_service_channel';
const notificationId = 888;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    NotificationService.initialize(),
    HiveService().initialize(),
    initializeService(),
  ]);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<Task>(taskBoxKey);
  final taskBox = Hive.box<Task>(taskBoxKey);

  Timer.periodic(const Duration(hours: 1), (timer) async {
    final currentTime = DateTime.now();
    final formattedTime = DateFormat.yMEd().add_jms().format(DateTime.now());
    debugPrint('[$formattedTime] Timer started. Background task initiated.');

    try {
      debugPrint('[$formattedTime] Checking for tasks to update...');
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty) {
          var shouldUpdate = task.notificationTime
                  .every((dateTime) => dateTime.isBefore(currentTime)) &&
              task.deleteWhenExpired;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate == null) {
              shouldUpdate = false;
            }
          }
          debugPrint(
              '[$formattedTime] Task key $key needs update: $shouldUpdate');
          return shouldUpdate;
        }
        debugPrint('[$formattedTime] Task key $key skipped.');
        return false;
      }).toList();

      debugPrint(
          '[$formattedTime] Found ${tasksToUpdate.length} tasks to update.');

      for (var key in tasksToUpdate) {
        final task = taskBox.get(key);
        if (task != null) {
          debugPrint(
              '[$formattedTime] Updating task key $key: Setting isActive to false.');
          task.isActive = false;
          await taskBox.put(key, task);
        }
      }

      debugPrint('[$formattedTime] Checking for keys to delete...');
      final keysToDelete = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        final shouldDelete =
            task != null && !task.isActive && task.deleteWhenExpired;
        debugPrint(
            '[$formattedTime] Task key $key marked for deletion: $shouldDelete');
        return shouldDelete;
      }).toList();

      debugPrint(
          '[$formattedTime] Found ${keysToDelete.length} keys to delete.');

      for (var key in keysToDelete) {
        debugPrint('[$formattedTime] Deleting task key $key.');
        await taskBox.delete(key);
      }

      if (kDebugMode) {
        final notificationTime =
            DateFormat.yMEd().add_jms().format(currentTime);
        debugPrint(
            '[$formattedTime] Sending notification about task execution.');
        notificationsPlugin.show(
          notificationId,
          'Task Cleaner Service',
          'Background task executed successfully at $notificationTime',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'Task Cleaner Service',
              icon: '@drawable/ic_bg_service_small',
            ),
          ),
        );
        debugPrint('[$formattedTime] Notification sent successfully.');
      }
    } catch (e, stackTrace) {
      debugPrint('[$formattedTime] Error in background task: $e');
      debugPrint('[$formattedTime] StackTrace: $stackTrace');
    }
  });

  service.on("stop").listen((event) {
    service.stopSelf();
  });
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      home: const HomeScreen(),
    );
  }
}
