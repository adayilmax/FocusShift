import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/daily_summary.dart';
import '../models/task_model.dart';

/// Exposes the FirestoreService to the widget tree
final firestoreServiceProvider = Provider((ref) => FirestoreService());

/// Streams the per-app hour limits from Firestore
final appLockLimitsProvider = StreamProvider.family<
    Map<String, int>, String>((ref, uid) {
  return ref.read(firestoreServiceProvider).watchAppLockLimits(uid);
});

/// Streams the last week's usage data (label/value pairs)
final lastWeekUsageProvider = StreamProvider.family<
    List<Map<String, dynamic>>, String>((ref, uid) {
  return ref.read(firestoreServiceProvider).watchLastWeekUsage(uid);
});

/// Fetches today's summary (focus time & tasks completed)
final dailySummaryProvider = FutureProvider.family<
    DailySummary, String>((ref, uid) {
  return ref.read(firestoreServiceProvider).fetchDailySummary(uid);
});

/// Streams the list of completed tasks
final completedTasksProvider = StreamProvider.family<
    List<TaskModel>, String>((ref, uid) {
  return ref.read(firestoreServiceProvider).watchCompletedTasks(uid);
});
