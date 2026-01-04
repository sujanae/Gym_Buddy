import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/models/workout_note.dart';
import 'package:gym_app/pages/home_page.dart';
import 'package:gym_app/theme/app_theme.dart';
import 'package:gym_app/theme/theme_provider.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  
  Hive.registerAdapter(WorkoutNoteAdapter());
  
  await Hive.openBox<WorkoutNote>('workout_notes');
  final settingsBox = await Hive.openBox('settings');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(settingsBox),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the theme provider for changes
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
