import 'package:hive/hive.dart';
part 'workout_note.g.dart';

@HiveType(typeId: 1)
class WorkoutNote extends HiveObject {
  @HiveField(0)
  DateTime workoutDate;

  @HiveField(1)
  String workoutTitle;

  @HiveField(2)
  String workoutTime;

  @HiveField(3)
  List<String> exercise;

  @HiveField(4)
  String notes;

  WorkoutNote({
    required this.workoutDate,
    required this.workoutTitle,
    required this.workoutTime,
    required this.exercise,
    required this.notes,
  });
}
