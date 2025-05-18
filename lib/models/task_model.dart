// simple model for one task; adapt your field names as needed
class TaskModel {
  final String id;
  final String time;
  final String label;
  final int profileCount;
  final bool completed;
  final String createdBy;

  TaskModel({
    required this.id,
    required this.time,
    required this.label,
    required this.profileCount,
    required this.completed,
    required this.createdBy,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return TaskModel(
      id: id,
      time: map['time'] as String? ?? '',
      label: map['label'] as String? ?? '',
      profileCount: map['profileCount'] as int? ?? 0,
      completed: map['completed'] as bool? ?? false,
      createdBy: map['createdBy'] as String? ?? '',
    );
  }
}
