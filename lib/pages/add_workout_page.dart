import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/workout_note.dart';

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
      final now = DateTime.now();
      final formattedTime = TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      ).format(context);

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
    Navigator.of(context).pop(); // ✅ Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    return Padding(
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text("Date: ${formatter.format(_selectedDate)}"),
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),

            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: "Workout Time",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _exerciseInputController,
                    decoration: const InputDecoration(labelText: "Exercise"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addExercise,
                ),
              ],
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_exercises[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeExercise(index),
                  ),
                );
              },
            ),

            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Notes (optional)"),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
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
