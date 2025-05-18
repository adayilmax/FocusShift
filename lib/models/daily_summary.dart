/// Represents the daily summary document for a user.
class DailySummary {
  final String focusTime;      // e.g. "3h 45m"
  final int tasksCompleted;    // e.g. 5

  DailySummary({
    required this.focusTime,
    required this.tasksCompleted,
  });

  // Optional: if you ever want to serialize back to JSON
  Map<String, dynamic> toMap() => {
    'focusTime': focusTime,
    'tasksCompleted': tasksCompleted,
  };
}
