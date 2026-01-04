import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/workout_note.dart';
import '../theme/app_colors.dart';


class AddWorkoutSheet extends StatefulWidget {
  final WorkoutNote? existingNote;
  final dynamic noteKey;

  const AddWorkoutSheet({super.key, this.existingNote, this.noteKey});

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _exerciseInputController =
      TextEditingController();
  List<String> _exercises = [];

  // Validation error messages
  String? _titleError;
  String? _timeError;
  String? _exerciseError;

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _selectedDate = widget.existingNote!.workoutDate;
      _titleController.text = widget.existingNote!.workoutTitle;
      _timeController.text = widget.existingNote!.workoutTime;
      _notesController.text = widget.existingNote!.notes;
      _exercises = List.from(widget.existingNote!.exercise);
    }
  }

  void _addExercise() {
    final text = _exerciseInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _exercises.add(text);
        _exerciseInputController.clear();
        _exerciseError = null; // clear error if previously set
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
      builder: (context, child) {
        return child!;
      },
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
      builder: (context, child) {
        return child!;
      },
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      setState(() {
        _timeController.text = formattedTime;
        _timeError = null;
      });
    }
  }

  void _saveWorkout() async {
    setState(() {
      _titleError = _titleController.text.trim().isEmpty
          ? 'Please enter a title'
          : null;
      _timeError = _timeController.text.trim().isEmpty
          ? 'Please enter workout time'
          : null;
      _exerciseError = _exercises.isEmpty ? 'Add at least one exercise' : null;
    });

    if (_titleError != null || _timeError != null || _exerciseError != null)
      return;

    // Clean notes: remove excessive newlines or spaces
    final rawNotes = _notesController.text.trim();
    final cleanedNotes = rawNotes
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n');

    final newWorkout = WorkoutNote(
      workoutDate: _selectedDate,
      workoutTitle: _titleController.text.trim(),
      workoutTime: _timeController.text.trim(),
      exercise: _exercises,
      notes: cleanedNotes,
    );

    final box = Hive.box<WorkoutNote>('workout_notes');

    if (widget.existingNote == null) {
      await box.add(newWorkout);
    } else {
      await box.put(widget.noteKey, newWorkout);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.existingNote == null ? "Add Workout" : "Edit Workout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Date: ${formatter.format(_selectedDate)}",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                    child: const Text("Change Date"),
                  ),
                ],
              ),

              // Workout Time
              GestureDetector(
                onTap: _pickTime,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _timeController,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: "Workout Time",
                      labelStyle: TextStyle(color: colorScheme.onSurface),
                      suffixIcon: Icon(
                        Icons.access_time,
                        color: colorScheme.primary,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      errorText: _timeError,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Workout Title
              TextField(
                controller: _titleController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Workout Title (e.g., Chest Day)",
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  errorText: _titleError,
                ),
              ),
              const SizedBox(height: 12),

              // Exercise input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _exerciseInputController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Exercise",
                        labelStyle: TextStyle(color: colorScheme.onSurface),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: colorScheme.primary),
                    onPressed: _addExercise,
                  ),
                ],
              ),

              if (_exerciseError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    _exerciseError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 10),

              // Exercise list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _exercises[index],
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeExercise(index),
                    ),
                  );
                },
              ),

              // Notes (optional)
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Notes (optional)",
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.save, color:  AppColors.text),
                label: const Text(
                  "Save Workout",
                  style: TextStyle(color:  AppColors.text),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: _saveWorkout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
