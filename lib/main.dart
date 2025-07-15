import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_note.dart';
import 'package:gym_app/pages/home_page.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for using platform channels like accessing files

  final dir =
      await getApplicationDocumentsDirectory(); //get a path to write the notes in app directory
  await Hive.initFlutter(dir.path); //initialize hive at that path
  Hive.registerAdapter(
    WorkoutNoteAdapter(),
  ); //registers a type adapter for the model,becoz hive dont know dart class
  await Hive.openBox<WorkoutNote>('workout_notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
