import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/workout_note.dart';
import '../theme/app_colors.dart';

class AddWorkoutSheet extends StatefulWidget {
  const AddWorkoutSheet({super.key});

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _exerciseInputController =
      TextEditingController();
  List<String> _exercises = [];

  void _addExercise() {
    final text = _exerciseInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _exercises.add(text);
        _exerciseInputController.clear();
      });
    }
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  void _saveWorkout() async {
    final time = _timeController.text.trim();
    final notes = _notesController.text.trim();

    if (time.isEmpty || _exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter time and at least one exercise"),
        ),
      );
      return;
    }

    final box = Hive.box<WorkoutNote>('workout_notes');
    final newWorkout = WorkoutNote(
      workoutDate: _selectedDate,
      workoutTime: time,
      exercise: _exercises,
      notes: notes,
    );

    await box.add(newWorkout);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Workout",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${formatter.format(_selectedDate)}",
                    style: const TextStyle(color: AppColors.text),
                  ),
                ),
                TextButton(
                  onPressed: _selectDate,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                  ),
                  child: const Text("Change Date"),
                ),
              ],
            ),

            // Time Picker
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: TextField(
                  controller: _timeController,
                  style: const TextStyle(color: AppColors.text),
                  decoration: const InputDecoration(
                    labelText: "Workout Time",
                    labelStyle: TextStyle(color: Colors.white70),
                    suffixIcon: Icon(
                      Icons.access_time,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Exercise Input + Add
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _exerciseInputController,
                    style: const TextStyle(color: AppColors.text),
                    decoration: const InputDecoration(
                      labelText: "Exercise",
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.accent),
                  onPressed: _addExercise,
                ),
              ],
            ),

            // Exercise List
            ListView.builder(
              shrinkWrap: true,
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _exercises[index],
                    style: const TextStyle(color: AppColors.text),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removeExercise(index),
                  ),
                );
              },
            ),

            // Notes Input
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                labelText: "Notes (optional)",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.save),
              label: const Text("Save Workout"),
              onPressed: _saveWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
