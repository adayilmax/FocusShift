/// Represents a single completed‐task entry.
class TaskModel {
  final String id;            // Firestore document ID
  final String time;          // e.g. "8:00 AM"
  final String label;         // e.g. "Study"
  final int profileCount;     // e.g. 2 (number of participants)

  TaskModel({
    required this.id,
    required this.time,
    required this.label,
    required this.profileCount,
  });

  // Optional: factory if you need to create from JSON
  factory TaskModel.fromMap(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      time: data['time'] as String? ?? '',
      label: data['label'] as String? ?? '',
      profileCount: data['profileCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'time': time,
    'label': label,
    'profileCount': profileCount,
  };
}
