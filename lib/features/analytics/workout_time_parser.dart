class WorkoutTimeParser {
  /// Parses workout time strings like "45 mins", "1h 30m", "90", "1 hour"
  /// Returns the total duration in minutes.
  static int parseToMinutes(String timeStr) {
    if (timeStr.isEmpty) return 0;

    final lowerTime = timeStr.toLowerCase().trim();
    
    // Case 1: Just numbers (e.g., "45")
    final justNumbers = int.tryParse(lowerTime);
    if (justNumbers != null) return justNumbers;

    int totalMinutes = 0;

    // Case 2: Handle "h" and "m" (e.g., "1h 30m", "45m")
    final hourRegex = RegExp(r'(\d+)\s*h');
    final minRegex = RegExp(r'(\d+)\s*m');

    final hourMatch = hourRegex.firstMatch(lowerTime);
    if (hourMatch != null) {
      totalMinutes += int.parse(hourMatch.group(1)!) * 60;
    }

    final minMatch = minRegex.firstMatch(lowerTime);
    if (minMatch != null) {
      totalMinutes += int.parse(minMatch.group(1)!);
    } else if (hourMatch == null) {
      // If no 'h' and no 'm', but contains numbers, assume those are minutes if "min" is present
      final genericNumRegex = RegExp(r'(\d+)');
      final genericMatch = genericNumRegex.firstMatch(lowerTime);
      if (genericMatch != null) {
        totalMinutes += int.parse(genericMatch.group(1)!);
      }
    }

    return totalMinutes;
  }
}
