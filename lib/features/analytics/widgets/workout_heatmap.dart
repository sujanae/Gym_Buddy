import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class WorkoutHeatmap extends StatelessWidget {
  final Map<DateTime, int> datasets;

  const WorkoutHeatmap({
    super.key,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Workout Consistency",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            HeatMap(
              datasets: datasets,
              colorMode: ColorMode.color,
              defaultColor: Colors.grey[300],
              textColor: Colors.black,
              showColorTip: false,
              showText: false,
              scrollable: true,
              size: 20,
              colorsets: {
                1: Colors.green[100]!,
                2: Colors.green[300]!,
                3: Colors.green[500]!,
                4: Colors.green[700]!,
                5: Colors.green[900]!,
              },
              onClick: (value) {
                // Potential feature: show workouts on that day
              },
            ),
          ],
        ),
      ),
    );
  }
}
