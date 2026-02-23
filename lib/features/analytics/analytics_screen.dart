import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analytics_provider.dart';
import 'widgets/streak_card.dart';
import 'widgets/stat_summary_card.dart';
import 'widgets/workout_heatmap.dart';
import 'widgets/exercise_bar_chart.dart';
import 'widgets/workout_type_pie_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Analytics"),
        centerTitle: true,
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.totalWorkouts == 0) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreakCard(
                  currentStreak: provider.currentStreak,
                  longestStreak: provider.longestStreak,
                ),
                const SizedBox(height: 24),
                
                Text(
                  "Activity Overview",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                  children: [
                    StatSummaryCard(
                      label: "Total Workouts",
                      value: "${provider.totalWorkouts}",
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                    StatSummaryCard(
                      label: "This Week",
                      value: "${provider.workoutsThisWeek}",
                      subValue: "/ ${provider.weeklyGoal}",
                      icon: Icons.calendar_view_week,
                      color: Colors.purple,
                    ),
                    StatSummaryCard(
                      label: "This Month",
                      value: "${provider.workoutsThisMonth}",
                      icon: Icons.calendar_month,
                      color: Colors.green,
                    ),
                    StatSummaryCard(
                      label: "Total Time",
                      value: _formatMinutes(provider.totalMinutes),
                      icon: Icons.timer,
                      color: Colors.red,
                    ),
                    StatSummaryCard(
                      label: "Avg. Duration",
                      value: "${provider.averageMinutes.toInt()}m",
                      icon: Icons.avg_time,
                      color: Colors.amber,
                    ),
                    StatSummaryCard(
                      label: "Exercises",
                      value: "${provider.uniqueExerciseCount}",
                      icon: Icons.list,
                      color: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                WorkoutHeatmap(datasets: provider.heatmapData),
                const SizedBox(height: 24),

                ExerciseBarChart(exerciseFrequency: provider.exerciseFrequency),
                const SizedBox(height: 24),

                WorkoutTypePieChart(workoutDistribution: provider.workoutTypeDistribution),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) return "${totalMinutes}m";
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (mins == 0) return "${hours}h";
    return "${hours}h ${mins}m";
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No data yet",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "Log some workouts to see your statistics and progress here!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
