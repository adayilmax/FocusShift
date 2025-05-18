import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_summary.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of per-app hourly limits for App Lock
  Stream<Map<String, int>> watchAppLockLimits(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('appLockLimits')
        .snapshots()
        .map((snapshot) {
      final limits = <String, int>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final hours = data['hours'] as int? ?? 0;
        limits[doc.id] = hours;
      }
      return limits;
    });
  }

  /// Stream of last week usage data: list of {label, value}
  Stream<List<Map<String, dynamic>>> watchLastWeekUsage(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('lastWeekUsage')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'label': data['label'] as String? ?? '',
        'value': data['value'] as int? ?? 0,
      };
    }).toList());
  }

  /// Fetch daily summary for the current date
  Future<DailySummary> fetchDailySummary(String uid) async {
    final today = DateTime.now();
    final dateId = '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummary')
        .doc(dateId)
        .get();
    final data = doc.data()!;
    return DailySummary(
      focusTime: data['focusTime'] as String? ?? '0h 0m',
      tasksCompleted: data['tasksCompleted'] as int? ?? 0,
    );
  }

  /// Stream of completed tasks, ordered by time
  Stream<List<TaskModel>> watchCompletedTasks(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('completedTasks')
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return TaskModel(
        id: doc.id,
        time: data['time'] as String? ?? '',
        label: data['label'] as String? ?? '',
        profileCount: data['profileCount'] as int? ?? 0,
      );
    }).toList());
  }

  /// Record a focus session under the current user
  Future<void> addFocusSession(
      String uid,
      int minutes,
      String topic,
      DateTime timestamp,
      ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('focusSessions')
        .add({
      'minutes': minutes,
      'topic': topic,
      'timestamp': Timestamp.fromDate(timestamp),
    });
  }
}


