import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_note.dart';
import 'package:gym_app/pages/home_page.dart';
import 'package:gym_app/theme/theme_provider.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for using platform channels like accessing files

  final dir =
      await getApplicationDocumentsDirectory(); //get a path to write the notes in app directory
  await Hive.initFlutter(dir.path); //initialize hive at that path
  Hive.registerAdapter(
    WorkoutNoteAdapter(),
  ); //registers a type adapter for the model,becoz hive dont know dart class
  await Hive.openBox<WorkoutNote>(
    'workout_notes',
  ); //opening a hive box for further things

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Gym Notes',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: themeProvider.primaryColor,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        appBarTheme: AppBarTheme(
          backgroundColor: themeProvider.primaryColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: themeProvider.primaryColor,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: themeProvider.primaryColor,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: themeProvider.primaryColor.shade700,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: themeProvider.primaryColor.shade400,
        ),
      ),
      home: const HomePage(),
    );
  }
}
