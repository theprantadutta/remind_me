import 'package:flutter/material.dart';
import 'package:remind_me/components/home_screen/floating_add_task_button.dart';
import 'package:remind_me/components/home_screen/home_screen_top_bar.dart';
import 'package:remind_me/components/home_screen/remind_me_list.dart';

import '../constants/selectors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: AnnotatedRegion(
        value: getDefaultSystemUiStyle(isDarkTheme),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  HomeScreenTopBar(),
                  RemindMeList(),
                ],
              ),
              FloatingAddTaskButton(),
            ],
          ),
        ),
      ),
    );
  }
}
