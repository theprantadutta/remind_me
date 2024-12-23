import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:remind_me/components/forms/date_time_select_layout.dart';
import 'package:remind_me/components/forms/duration_input_field_layout.dart';
import 'package:remind_me/components/forms/input_field_layout.dart';
import 'package:remind_me/components/forms/multi_date_time_select_layout.dart';
import 'package:remind_me/entities/task.dart';
import 'package:remind_me/hive/hive_boxes.dart';
import 'package:remind_me/screens/home_screen.dart';
import 'package:remind_me/services/notification_service.dart';

import '../components/create_new_task_screen/create_new_task_tab_bar.dart';
import '../components/forms/input_field_switch_layout.dart';
import '../constants/selectors.dart';
import '../enums/recurrence_type.dart';
import '../packages/swipeable_button_view/swipeable_button_view.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? existingTask;

  const CreateTaskScreen({
    super.key,
    this.existingTask,
  });

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  String _id = nanoid();
  final TextEditingController _title = TextEditingController(text: '');
  final TextEditingController _description = TextEditingController(text: '');
  final TextEditingController _recurringCount =
      TextEditingController(text: '5');
  bool _isActive = true;
  bool _deleteWhenExpired = true;
  List<DateTime> _notificationTime = [];
  // RecurrenceType _recurrenceType = RecurrenceType.none;
  bool _enableRecurring = false;
  int? _recurrentInterval = 3;
  DateTime? _recurrenceEndDate;

  bool isFinished = false;

  bool hasErrors = true;

  @override
  void initState() {
    super.initState();
    final existingTask = widget.existingTask;
    if (existingTask == null) return;
    final now = DateTime.now();
    setState(() {
      _id = existingTask.id;
      _title.text = existingTask.title;
      _description.text = existingTask.description;
      _isActive = existingTask.isActive;
      _deleteWhenExpired = existingTask.deleteWhenExpired;
      _notificationTime = existingTask.notificationTime;
      _enableRecurring = existingTask.enableRecurring;
      _recurringCount.text = existingTask.recurrenceCount.toString();
      _recurrentInterval = existingTask.recurrenceIntervalInSeconds ?? 3;
      _recurrenceEndDate = existingTask.recurrenceEndDate ??
          DateTime(
            now.year,
            now.month + 1,
            now.day,
          );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _description.dispose();
  }

  void _addDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _notificationTime.add(DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          ));
        });
      }
    }
  }

  void _removeDateTime(int index) {
    setState(() {
      _notificationTime.removeAt(index);
    });
  }

  bool isFormValid() {
    return (_title.text.isNotEmpty &&
        _description.text.isNotEmpty &&
        _notificationTime.isNotEmpty);
  }

  RepeatInterval mapRecurrenceToInterval(RecurrenceType recurrenceType) {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return RepeatInterval.daily;
      case RecurrenceType.weekly:
        return RepeatInterval.weekly;
      case RecurrenceType.minute:
        return RepeatInterval.everyMinute;
      case RecurrenceType.hour:
        return RepeatInterval.hourly;
      // Add more cases if needed
      default:
        throw UnsupportedError('Unsupported RecurrenceType');
    }
  }

  bool areAllDatesInFuture(List<DateTime> notificationTime) {
    final now = DateTime.now();
    return notificationTime.every((dateTime) => dateTime.isAfter(now));
  }

  saveAndScheduleTask() async {
    debugPrint("saveAndScheduleTask called");

    if (!areAllDatesInFuture(_notificationTime)) {
      debugPrint("Validation failed: Not all dates are in the future.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Future Date Time Only'),
        ),
      );
      setState(() {
        isFinished = true;
        hasErrors = true;
      });
      return;
    }

    // Cancel any existing notification for this task ID
    debugPrint(
        "Cancelling existing notifications for task ID: ${_id.hashCode}");
    await NotificationService().cancelNotification(_id.hashCode);

    var task = Task(
      id: _id,
      title: _title.text,
      description: _description.text,
      isActive: _isActive,
      deleteWhenExpired: _deleteWhenExpired,
      notificationTime: _notificationTime,
      enableRecurring: _enableRecurring,
      recurrenceCount: int.parse(_recurringCount.text),
      recurrenceIntervalInSeconds: _recurrentInterval,
      recurrenceEndDate: _enableRecurring ? null : _recurrenceEndDate,
    );

    debugPrint("Saving task to Hive: ${task.toString()}");
    final taskBox = Hive.box<Task>(taskBoxKey);
    await taskBox.put(_id, task);

    // Schedule notifications
    if (_notificationTime.isNotEmpty) {
      debugPrint(
          "Scheduling notifications. Notification times: $_notificationTime");

      if (!_enableRecurring) {
        for (var dateTime in _notificationTime) {
          debugPrint("Scheduling non-recurring notification for: $dateTime");
          await NotificationService().scheduleNotification(
            id: _id.hashCode, // Unique ID for each notification
            title: _title.text,
            body: _description.text,
            scheduledDateTime: dateTime,
          );
        }
      } else {
        if (_recurrentInterval == null) {
          debugPrint("Recurring interval is null. Exiting scheduling.");
          return;
        }

        debugPrint(
            "Scheduling recurring notifications. Start time: ${_notificationTime.first}");
        DateTime startTime =
            _notificationTime.first; // Assuming a single start time

        for (int i = 0; i < int.parse(_recurringCount.text); i++) {
          DateTime scheduledTime =
              startTime.add(Duration(seconds: _recurrentInterval! * i));
          if (scheduledTime.isAfter(DateTime.now())) {
            debugPrint(
                "Scheduling recurring notification for: $scheduledTime with ID: ${_id.hashCode + 1000 + i}");
            await NotificationService().scheduleNotification(
              id: _id.hashCode + 1000 + i, // Ensure IDs are unique
              title: _title.text,
              body: _description.text,
              scheduledDateTime: scheduledTime,
            );
          } else {
            debugPrint("Skipping notification for past time: $scheduledTime");
          }
        }
      }
    } else {
      debugPrint("No notification times provided. Skipping scheduling.");
    }

    setState(() {
      hasErrors = false;
      isFinished = true;
    });

    debugPrint(
        "Task scheduling completed. isFinished: $isFinished, hasErrors: $hasErrors");
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion(
        value: getDefaultSystemUiStyle(isDarkTheme),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreateNewTaskTabBar(
                  task: widget.existingTask,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5,
                  ),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.87,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InputFieldSwitchLayout(
                            index: 0,
                            label: "Active Status",
                            value: _isActive,
                            onChanged: (newValue) {
                              setState(() {
                                _isActive = newValue;
                              });
                            },
                          ),
                          InputFieldLayout(
                            index: 1,
                            label: 'Title',
                            hintText: 'Enter Task Title',
                            textEditingController: _title,
                          ),
                          InputFieldLayout(
                            index: 2,
                            label: 'Description',
                            hintText: 'Enter Task Description',
                            maxLines: 2,
                            textEditingController: _description,
                          ),
                          MultiDateTimeSelectLayout(
                            index: 3,
                            label: 'Notification Time',
                            selectedDates: _notificationTime,
                            onAddDateTime: _addDateTime,
                            onRemoveDateTime: _removeDateTime,
                          ),
                          InputFieldSwitchLayout(
                            index: 4,
                            label: "Enable Recurring",
                            value: _enableRecurring,
                            onChanged: (newValue) {
                              setState(() {
                                _enableRecurring = newValue;
                              });
                            },
                          ),
                          if (_enableRecurring)
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  DurationInputFieldLayout(
                                    index: 4,
                                    label: "Recurrence Interval",
                                    hintText:
                                        "Pick Recurrence (In Hours, Minutes)",
                                    onChange: (seconds) => setState(
                                      () => _recurrentInterval = seconds,
                                    ),
                                  ),
                                  InputFieldLayout(
                                    index: 4,
                                    label: 'Recurrence Count',
                                    hintText: 'Enter Recurrence Count',
                                    textEditingController: _recurringCount,
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                      decimal: false,
                                      signed: false,
                                    ),
                                  ),
                                  DateTimeSelectLayout(
                                    index: 4,
                                    label: "Recurrence End Date",
                                    selectedDateTime: _recurrenceEndDate == null
                                        ? 'Never'
                                        : DateFormat('dd MMM, yyyy')
                                            .format(_recurrenceEndDate!),
                                    onChange: () async {
                                      final now = DateTime.now();
                                      final dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: _recurrenceEndDate,
                                        firstDate: now,
                                        lastDate: DateTime(
                                          now.year + 1,
                                          now.month,
                                          now.day,
                                        ),
                                      );
                                      setState(() {
                                        _recurrenceEndDate = dateTime;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          InputFieldSwitchLayout(
                            index: 5,
                            label: "Delete When Expired",
                            value: _deleteWhenExpired,
                            onChanged: (newValue) {
                              setState(() {
                                _deleteWhenExpired = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: isFormValid() ? 1.0 : 0.6,
                            child: SwipeableButtonView(
                              height: 50,
                              isActive: isFormValid(),
                              buttonText: 'SLIDE TO CREATE TASK',
                              buttontextstyle: const TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              buttonWidget: Container(
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                              activeColor: Colors.grey.shade700,
                              // activeColor: Colors.blueGrey,
                              isFinished: isFinished,
                              onWaitingProcess: saveAndScheduleTask,
                              onFinish: () async {
                                if (hasErrors) {
                                  setState(() {
                                    isFinished = false;
                                    hasErrors = true;
                                  });
                                  return;
                                }
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    fullscreenDialog: false,
                                    child: const HomeScreen(),
                                  ),
                                );
                                setState(() => isFinished = false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
