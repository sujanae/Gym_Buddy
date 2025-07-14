import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_note.dart';
import 'package:gym_app/pages/add_workout_page.dart';
import 'package:gym_app/theme/app_colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "🏋️ Gym App",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
        ),
        backgroundColor: AppColors.primary,
      ),

      // drawer: const Drawer(
      //   backgroundColor: AppColors.background,
      //   child: DrawerHeader(
      //     child: Center(
      //       child: Text(
      //         "Coming Soon...",
      //         style: TextStyle(color: AppColors.text),
      //       ),
      //     ),
      //   ),
      // ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WorkoutNote>('workout_notes').listenable(),
        builder: (context, Box<WorkoutNote> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No workouts logged yet 💪",
                style: TextStyle(fontSize: 18, color: AppColors.text),
              ),
            );
          }

          final notes = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: notes.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                color: AppColors.secondary,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEE, MMM d').format(note.workoutDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            note.workoutTime,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Exercise List
                      ...note.exercise.map(
                        (e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              size: 18,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e,
                                style: const TextStyle(color: AppColors.text),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Optional Notes
                      if (note.notes.isNotEmpty) ...[
                        const Divider(height: 20, color: Colors.white24),
                        Text(
                          "Notes: ${note.notes}",
                          style: const TextStyle(
                            color: AppColors.text,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Workout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.background,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const AddWorkoutSheet(),
          );
        },
      ),
    );
  }
}
