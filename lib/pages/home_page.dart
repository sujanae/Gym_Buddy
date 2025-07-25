// HomePage.dart (full updated)

import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_note.dart';
import 'package:gym_app/pages/add_workout_page.dart';
import 'package:gym_app/theme/app_colors.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WorkoutNote? _recentlyDeleted;
  dynamic _recentlyDeletedKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "🏋️‍♂️ Gym Buddy",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            shadows: [
              // Shadow(
              //   offset: Offset(1, 1),
              //   blurRadius: 1.5,
              //   color: Colors.black26,
              // ),
            ],
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      // drawer: const Drawer(backgroundColor: AppColors.background),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WorkoutNote>('workout_notes').listenable(),
        builder: (context, Box<WorkoutNote> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No workouts logged yet 💪",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final notes = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: notes.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final note = notes[index];
              final key = box.keyAt(box.length - 1 - index);

              return Dismissible(
                key: Key(key.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.secondary,
                      title: const Text(
                        "Delete Workout",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to delete this workout?",
                        style: TextStyle(color: AppColors.text),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  setState(() {
                    _recentlyDeleted = note;
                    _recentlyDeletedKey = key;
                    box.delete(key);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Workout deleted"),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          if (_recentlyDeleted != null) {
                            box.put(_recentlyDeletedKey, _recentlyDeleted!);
                          }
                        },
                      ),
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) =>
                          AddWorkoutSheet(existingNote: note, noteKey: key),
                    );
                  },
                  child: _buildWorkoutCard(note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        icon: const Icon(
          Icons.add,
          color: AppColors.text,
          shadows: [
            // Shadow(
            //   offset: Offset(1, 1),
            //   blurRadius: 1.5,
            //   color: Colors.black26,
            // ),
          ],
        ),
        label: const Text(
          "Add Workout",
          style: TextStyle(
            color: AppColors.text,

            fontWeight: FontWeight.bold,
            shadows: [
              // Shadow(
              //   offset: Offset(1.0, 1.0),
              //   blurRadius: 2.0,
              //   color: Colors.black26,
              // ),
            ],
          ),
        ),

        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const AddWorkoutSheet(),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutNote note) {
    return Card(
      color: AppColors.secondary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              note.workoutTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 6),

            const SizedBox(height: 10),
            ...note.exercise.map(
              (e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 18,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(e, style: TextStyle(color: AppColors.text)),
                  ),
                ],
              ),
            ),
            if (note.notes.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                "Notes: ${note.notes.trim()}",
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
  }
}
