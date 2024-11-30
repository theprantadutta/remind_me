import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:remind_me/services/hive_service.dart';

import 'screens/home_screen.dart';

void main() async {
  await HiveService().initialize();
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      home: HomeScreen(),
    );
  }
}
