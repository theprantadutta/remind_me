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
import '../components/forms/select_input_field_layout.dart';
import '../constants/selectors.dart';
import '../enums/recurrence_type.dart';
import '../packages/swipeable_button_view/swipeable_button_view.dart';
import '../utils/functions.dart';

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
  bool _isActive = true;
  bool _deleteWhenExpired = true;
  List<DateTime> _notificationTime = [];
  RecurrenceType _recurrenceType = RecurrenceType.none;
  int? _recurrentInterval = 3;
  DateTime _recurrenceEndDate = DateTime(
    DateTime.now().year + 1,
    DateTime.now().month,
    DateTime.now().day,
  );

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
      _recurrenceType =
          getRecurrenceTypeFromString(existingTask.recurrenceType);
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

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion(
        value: getDefaultSystemUiStyle(isDarkTheme),
        child: SafeArea(
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
                        SelectInputFieldLayout(
                          index: 4,
                          label: "Recurrence Type",
                          selectedValue:
                              getRecurrenceTypeString(_recurrenceType),
                          options: getRecurrenceTypeStrings(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _recurrenceType =
                                    getRecurrenceTypeFromString(newValue);
                              });
                            }
                          },
                        ),
                        if (_recurrenceType != RecurrenceType.none)
                          Column(
                            children: [
                              DurationInputFieldLayout(
                                index: 4,
                                label: "Recurrence Interval",
                                hintText:
                                    "Pick Recurrence (In Seconds, Minutes)",
                                onChange: (seconds) => setState(
                                  () => _recurrentInterval = seconds,
                                ),
                              ),
                              DateTimeSelectLayout(
                                index: 4,
                                label: "Recurrence End Date",
                                selectedDateTime: DateFormat('dd MMM, yyyy')
                                    .format(_recurrenceEndDate),
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
                                  if (dateTime == null) return;
                                  setState(() {
                                    _recurrenceEndDate = dateTime;
                                  });
                                },
                              ),
                            ],
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
                            onWaitingProcess: () async {
                              if (!areAllDatesInFuture(_notificationTime)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Plese select Future Date Time Only'),
                                  ),
                                );
                                setState(() {
                                  isFinished = true;
                                  hasErrors = true;
                                });
                                return;
                              }

                              final isRecurrenceTypeInValid =
                                  _recurrenceType == RecurrenceType.none;

                              // Cancel any existing notification for this task ID
                              await NotificationService()
                                  .cancelNotification(_id.hashCode);

                              var task = Task(
                                id: _id,
                                title: _title.text,
                                description: _description.text,
                                isActive: _isActive,
                                deleteWhenExpired: _deleteWhenExpired,
                                notificationTime: _notificationTime,
                                recurrenceType:
                                    getRecurrenceTypeString(_recurrenceType),
                                recurrenceIntervalInSeconds:
                                    isRecurrenceTypeInValid
                                        ? null
                                        : _recurrentInterval,
                                recurrenceEndDate: isRecurrenceTypeInValid
                                    ? null
                                    : _recurrenceEndDate,
                              );

                              final taskBox = Hive.box<Task>(taskBoxKey);
                              await taskBox.put(_id, task);

                              // Schedule notifications
                              if (_notificationTime.isNotEmpty) {
                                if (isRecurrenceTypeInValid) {
                                  for (var dateTime in _notificationTime) {
                                    await NotificationService()
                                        .scheduleNotification(
                                      id: _id
                                          .hashCode, // Unique ID for each notification
                                      title: _title.text,
                                      body: _description.text,
                                      scheduledDateTime: dateTime,
                                    );
                                  }
                                } else {
                                  RepeatInterval interval =
                                      mapRecurrenceToInterval(_recurrenceType);
                                  await NotificationService()
                                      .scheduleIntervalNotification(
                                    id: _id.hashCode,
                                    title: _title.text,
                                    body: _description.text,
                                    interval: interval,
                                  );
                                }
                              }

                              setState(() {
                                hasErrors = false;
                                isFinished = true;
                              });
                            },
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
    );
  }
}
