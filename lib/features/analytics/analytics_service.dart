import 'package:hive/hive.dart';
import 'package:gym_app/models/workout_note.dart';
import 'workout_time_parser.dart';

class AnalyticsService {
  final Box<WorkoutNote> _box;

  AnalyticsService(this._box);

  List<WorkoutNote> get allWorkouts =>
      _box.values.toList()..sort((a, b) => a.workoutDate.compareTo(b.workoutDate));

  // --- Streak Logic ---
  int getCurrentStreak() {
    final workouts = allWorkouts;
    if (workouts.isEmpty) return 0;

    final workoutDates = workouts.map((w) => DateTime(w.workoutDate.year, w.workoutDate.month, w.workoutDate.day)).toSet().toList()..sort((a, b) => b.compareTo(a));

    DateTime today = DateTime.now();
    DateTime lastDay = DateTime(today.year, today.month, today.day);
    
    // If the latest workout is not today or yesterday, streak is broken
    if (workoutDates.first.isBefore(lastDay.subtract(const Duration(days: 1)))) {
      return 0;
    }

    int streak = 0;
    DateTime currentCheck = workoutDates.first;

    for (int i = 0; i < workoutDates.length; i++) {
        if (i == 0) {
            streak++;
            continue;
        }

        if (workoutDates[i-1].difference(workoutDates[i]).inDays == 1) {
            streak++;
        } else {
            break;
        }
    }

    return streak;
  }

  int getLongestStreak() {
    final workouts = allWorkouts;
    if (workouts.isEmpty) return 0;

    final workoutDates = workouts.map((w) => DateTime(w.workoutDate.year, w.workoutDate.month, w.workoutDate.day)).toSet().toList()..sort();

    int longest = 0;
    int current = 0;

    for (int i = 0; i < workoutDates.length; i++) {
        if (i == 0) {
            current = 1;
        } else {
            if (workoutDates[i].difference(workoutDates[i-1]).inDays == 1) {
                current++;
            } else {
                if (current > longest) longest = current;
                current = 1;
            }
        }
    }
    if (current > longest) longest = current;

    return longest;
  }

  // --- Workout Counts ---
  int getWorkoutsThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfRange = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    return allWorkouts.where((w) => w.workoutDate.isAfter(startOfRange) || w.workoutDate.isAtSameMomentAs(startOfRange)).length;
  }

  int getWorkoutsThisMonth() {
    final now = DateTime.now();
    return allWorkouts.where((w) => w.workoutDate.year == now.year && w.workoutDate.month == now.month).length;
  }

  int getTotalWorkouts() => allWorkouts.length;

  // --- Time Stats ---
  int getTotalMinutes() {
    return allWorkouts.fold(0, (sum, w) => sum + WorkoutTimeParser.parseToMinutes(w.workoutTime));
  }

  double getAverageMinutes() {
    final total = getTotalWorkouts();
    if (total == 0) return 0;
    return getTotalMinutes() / total;
  }

  // --- Exercise Stats ---
  Map<String, int> getExerciseFrequency() {
    final freq = <String, int>{};
    for (var workout in allWorkouts) {
      for (var ex in workout.exercise) {
        final cleanEx = ex.trim();
        if (cleanEx.isNotEmpty) {
          freq[cleanEx] = (freq[cleanEx] ?? 0) + 1;
        }
      }
    }
    return freq;
  }

  int getUniqueExerciseCount() {
    return getExerciseFrequency().length;
  }

  double getExerciseDiversityScore() {
    final freq = getExerciseFrequency();
    if (freq.isEmpty) return 0;
    final totalLogs = freq.values.fold(0, (sum, count) => sum + count);
    return (freq.length / totalLogs) * 100;
  }

  // --- Grouping ---
  Map<int, int> getWorkoutsByWeekday() {
    final counts = <int, int>{};
    for (var workout in allWorkouts) {
      final day = workout.workoutDate.weekday;
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  Map<DateTime, int> getHeatmapData() {
    final data = <DateTime, int>{};
    for (var workout in allWorkouts) {
      final date = DateTime(workout.workoutDate.year, workout.workoutDate.month, workout.workoutDate.day);
      data[date] = (data[date] ?? 0) + 1;
    }
    return data;
  }

  Map<String, int> getWorkoutTypeDistribution() {
    final dist = <String, int>{};
    for (var workout in allWorkouts) {
      final title = workout.workoutTitle.trim();
      if (title.isNotEmpty) {
        dist[title] = (dist[title] ?? 0) + 1;
      }
    }
    return dist;
  }
}
