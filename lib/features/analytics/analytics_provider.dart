import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:gym_app/models/workout_note.dart';
import 'analytics_service.dart';

class AnalyticsProvider with ChangeNotifier {
  late AnalyticsService _service;
  final Box<WorkoutNote> _box;

  AnalyticsProvider(this._box) {
    _service = AnalyticsService(_box);
    // Listen for changes in the box to refresh analytics
    _box.listenable().addListener(_onBoxChanged);
  }

  void _onBoxChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _box.listenable().removeListener(_onBoxChanged);
    super.dispose();
  }

  // --- Statistics ---
  int get currentStreak => _service.getCurrentStreak();
  int get longestStreak => _service.getLongestStreak();
  
  int get workoutsThisWeek => _service.getWorkoutsThisWeek();
  int get workoutsThisMonth => _service.getWorkoutsThisMonth();
  int get totalWorkouts => _service.getTotalWorkouts();

  int get totalMinutes => _service.getTotalMinutes();
  double get averageMinutes => _service.getAverageMinutes();

  Map<String, int> get exerciseFrequency => _service.getExerciseFrequency();
  int get uniqueExerciseCount => _service.getUniqueExerciseCount();
  double get exerciseDiversityScore => _service.getExerciseDiversityScore();

  Map<int, int> get workoutsByWeekday => _service.getWorkoutsByWeekday();
  Map<DateTime, int> get heatmapData => _service.getHeatmapData();
  Map<String, int> get workoutTypeDistribution => _service.getWorkoutTypeDistribution();

  // Weekly Goal (Could be made configurable later)
  int get weeklyGoal => 4; 
}
