import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:remind_me/entities/task.dart';
import 'package:remind_me/hive/hive_boxes.dart';
import 'package:remind_me/main.dart';
import 'package:remind_me/screens/alarm_screen.dart';
import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // initalize local notifications
//   static Future localNotiInit() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//             // onDidReceiveLocalNotification: (id, title, body, payload) {},
//             );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: onNotificationTap,
//     );

//     if (Platform.isAndroid) {
//       _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//     }
//     if (Platform.isIOS) {
//       _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions();
//     }
//   }

//   // on tap local notification in foreground
//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     // AppNavigation.rootNavigatorKey.currentState!.pushNamed(
//     //   NoticeScreen.name,
//     //   arguments: notificationResponse,
//     // );
//   }

//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'com.pranta.quotely',
//       'Quotely',
//       channelDescription: 'Quotely Application',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       icon: '@mipmap/ic_launcher',
//       showWhen: true,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     // Generate a unique notification ID
//     int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     await _flutterLocalNotificationsPlugin.show(
//       notificationId,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  static Future<void> initialize() async {
    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    // Overall settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    // Ask For Permissions
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }

  // Handle notification tap
  static void onNotificationTap(NotificationResponse notificationResponse) {
    debugPrint('Notification tapped: ${notificationResponse.payload}');

    if (notificationResponse.payload != null) {
      // Check if alarm is enabled for this task
      final taskBox = Hive.box<Task>(taskBoxKey);
      final task = taskBox.get(notificationResponse.payload);

      if (task != null && task.enableAlarm) {
        // Navigate to alarm screen if alarm is enabled
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => AlarmScreen(
              taskId: notificationResponse.payload,
              title: task.title,
              body: task.description,
            ),
          ),
        );
      } else {
        // Just show a regular notification (no alarm screen)
        debugPrint(
            'Alarm not enabled for task: ${notificationResponse.payload}');
      }
    }
  }

  // Show simple local notification
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'com.pranta.remindme', // Channel ID
      'Remind Me', // Channel Name
      channelDescription: 'Remind Me Application',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Generate a unique notification ID
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? payload,
    bool enableAlarm = false,
  }) async {
    final tz.TZDateTime tzScheduledDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    debugPrint(
        'Scheduling notification: ID=$id, Title=$title, Body=$body, ScheduledTime=$scheduledDateTime (TZ=$tzScheduledDateTime)');

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel_id',
        'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        fullScreenIntent: enableAlarm, // Only show full screen for alarms
      ),
    );

    await NotificationService._flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDateTime,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleIntervalNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval interval,
    bool enableAlarm = false,
  }) async {
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'interval_channel_id',
        'Interval Notifications',
        channelDescription: 'Channel for interval notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        fullScreenIntent: enableAlarm, // Only show full screen for alarms
      ),
    );

    await NotificationService._flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      interval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
