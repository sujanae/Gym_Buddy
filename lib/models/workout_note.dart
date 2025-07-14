import 'package:hive/hive.dart';
part 'workout_note.g.dart';

@HiveType(typeId: 1)
class WorkoutNote extends HiveObject {
  @HiveField(0)
  DateTime workoutDate;

  @HiveField(1)
  String workoutTime;

  @HiveField(2)
  List<String> exercise;

  @HiveField(3)
  String notes;

  WorkoutNote({
    required this.workoutDate,
    required this.workoutTime,
    required this.exercise,
    required this.notes,
  });
}
