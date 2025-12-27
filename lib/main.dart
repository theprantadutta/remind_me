import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:remind_me/hive/hive_registrar.g.dart';
import 'package:remind_me/providers/calendar_provider.dart';
import 'package:remind_me/providers/category_provider.dart';
import 'package:remind_me/providers/loading_provider.dart';
import 'package:remind_me/providers/statistics_provider.dart';
import 'package:remind_me/providers/task_provider.dart';
import 'package:remind_me/providers/theme_provider.dart';
import 'package:remind_me/services/hive_service.dart';
import 'package:remind_me/services/migration_service.dart';
import 'package:remind_me/services/notification_service.dart';
import 'package:remind_me/services/timezone_service.dart';
import 'package:remind_me/services/logger_service.dart';

import 'entities/task.dart';
import 'hive/hive_boxes.dart';
import 'navigation/app_shell.dart';
import 'screens/alarm_screen.dart';
import 'screens/onboarding_screen.dart';

const notificationChannelId = 'task_service_channel';
const notificationId = 888;

// Global navigator key for handling notification taps
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggerService.instance;
  logger.info('App starting...', tag: 'Main');

  // Initialize timezone with auto-detection
  await TimezoneService.instance.initialize();
  logger.info('Timezone: ${TimezoneService.instance.currentTimezone}', tag: 'Main');

  // Initialize core services
  await Future.wait([
    NotificationService.initialize(),
    HiveService.instance.initialize(),
    initializeService(),
  ]);

  // Run data migrations
  await MigrationService.instance.runMigrations();

  logger.info('All services initialized', tag: 'Main');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()..loadStatistics()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()..initialize()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
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

  debugPrint('[Background Service] Starting background service...');

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<Task>(taskBoxKey);
  final taskBox = Hive.box<Task>(taskBoxKey);

  debugPrint(
      '[Background Service] Background service initialized successfully');

  Timer.periodic(const Duration(hours: 1), (timer) async {
    final currentTime = tz.TZDateTime.now(tz.local);
    final formattedTime = DateFormat.yMEd().add_jms().format(currentTime);
    debugPrint('[$formattedTime] Background task timer triggered');
    debugPrint('[$formattedTime] Current time: $currentTime');

    try {
      debugPrint('[$formattedTime] Checking for tasks to update...');

      // IMPROVED LOGIC: Check if ANY notification time is expired, not ALL
      final tasksToUpdate = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        if (task != null && task.notificationTime.isNotEmpty && task.isActive) {
          // Check if task has expired notification times
          final hasExpiredTime = task.notificationTime
              .any((dateTime) => dateTime.isBefore(currentTime));

          // For recurring tasks, only expire if they have an end date and it's passed
          bool shouldExpire = false;
          if (task.enableRecurring) {
            if (task.recurrenceEndDate != null) {
              shouldExpire = task.recurrenceEndDate!.isBefore(currentTime) &&
                  hasExpiredTime;
            } else {
              // Infinite recurring tasks don't expire automatically
              shouldExpire = false;
            }
          } else {
            // Non-recurring tasks expire when their notification time passes
            shouldExpire = hasExpiredTime;
          }

          debugPrint(
              '[$formattedTime] Task "${task.title}" (key: $key) - Expired: $shouldExpire, HasExpiredTime: $hasExpiredTime, DeleteWhenExpired: ${task.deleteWhenExpired}');
          return shouldExpire;
        }
        return false;
      }).toList();

      debugPrint(
          '[$formattedTime] Found ${tasksToUpdate.length} tasks to deactivate.');

      // Deactivate expired tasks
      for (var key in tasksToUpdate) {
        final task = taskBox.get(key);
        if (task != null) {
          debugPrint(
              '[$formattedTime] Deactivating expired task: "${task.title}" (key: $key)');
          task.isActive = false;
          await taskBox.put(key, task);
        }
      }

      debugPrint('[$formattedTime] Checking for tasks to delete...');
      final keysToDelete = taskBox.keys.where((key) {
        final task = taskBox.get(key);
        final shouldDelete =
            task != null && !task.isActive && task.deleteWhenExpired;
        if (shouldDelete) {
          debugPrint(
              '[$formattedTime] Task "${task.title}" (key: $key) marked for deletion');
        }
        return shouldDelete;
      }).toList();

      debugPrint(
          '[$formattedTime] Found ${keysToDelete.length} tasks to delete.');

      // Delete inactive tasks marked for auto-deletion
      for (var key in keysToDelete) {
        final task = taskBox.get(key);
        debugPrint(
            '[$formattedTime] Deleting task: "${task?.title ?? 'Unknown'}" (key: $key)');
        await taskBox.delete(key);
      }

      // Send notification about cleanup (only in debug mode)
      if (kDebugMode) {
        final summaryMessage =
            'Cleanup completed: ${tasksToUpdate.length} deactivated, ${keysToDelete.length} deleted';

        debugPrint('[$formattedTime] $summaryMessage');
        notificationsPlugin.show(
          notificationId,
          'Task Cleaner Service',
          summaryMessage,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'Task Cleaner Service',
              icon: '@drawable/ic_bg_service_small',
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[$formattedTime] Error in background task: $e');
      debugPrint('[$formattedTime] StackTrace: $stackTrace');

      // Send error notification in debug mode
      if (kDebugMode) {
        notificationsPlugin.show(
          notificationId + 1, // Different ID for error notifications
          'Task Cleaner Service - Error',
          'Background task failed: ${e.toString()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'Task Cleaner Service',
              icon: '@drawable/ic_bg_service_small',
            ),
          ),
        );
      }
    }

    debugPrint('[$formattedTime] Background task cycle completed');
  });

  service.on("stop").listen((event) {
    service.stopSelf();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Remind Me',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const _AppWrapper(),
          routes: {
            '/alarm': (context) => const AlarmScreen(),
          },
        );
      },
    );
  }
}

/// Wrapper widget that checks onboarding status
class _AppWrapper extends StatefulWidget {
  const _AppWrapper();

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> {
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeen = prefs.getBool(OnboardingScreen.hasSeenOnboardingKey) ?? false;
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = hasSeen;
        });
      }
    } catch (e) {
      // Default to showing main app on error
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking
    if (_hasSeenOnboarding == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show onboarding or main app
    return _hasSeenOnboarding! ? const AppShell() : const OnboardingScreen();
  }
}
