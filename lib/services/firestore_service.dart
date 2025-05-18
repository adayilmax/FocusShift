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
        .map((snap) {
      final limits = <String, int>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        limits[doc.id] = (data['hours'] as int?) ?? 0;
      }
      return limits;
    });
  }

  /// Stream of last-week usage data
  Stream<List<Map<String, dynamic>>> watchLastWeekUsage(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('lastWeekUsage')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      return {
        'label': (data['label'] as String?) ?? '',
        'value': (data['value'] as int?) ?? 0,
      };
    }).toList());
  }

  /// Fetch today's summary (or defaults if none)
  Future<DailySummary> fetchDailySummary(String uid) async {
    final now = DateTime.now();
    final dateId = '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    final docSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummary')
        .doc(dateId)
        .get();

    if (!docSnap.exists || docSnap.data() == null) {
      return DailySummary(focusTime: '0h 0m', tasksCompleted: 0);
    }

    final data = docSnap.data()!;
    return DailySummary(
      focusTime: (data['focusTime'] as String?) ?? '0h 0m',
      tasksCompleted: (data['tasksCompleted'] as int?) ?? 0,
    );
  }

  /// Stream of completed tasks, now including `completed` & `createdBy`
  Stream<List<TaskModel>> watchCompletedTasks(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('completedTasks')
        .orderBy('time')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      return TaskModel(
        id: doc.id,
        time: (data['time'] as String?) ?? '',
        label: (data['label'] as String?) ?? '',
        profileCount: (data['profileCount'] as int?) ?? 0,
        completed: (data['completed'] as bool?) ?? true,
        createdBy: (data['createdBy'] as String?) ?? uid,
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
