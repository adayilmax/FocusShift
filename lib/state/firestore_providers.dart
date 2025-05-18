
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/daily_summary.dart';
import '../models/task_model.dart';

/// Provides a singleton instance of FirestoreService.
final firestoreServiceProvider =
Provider<FirestoreService>((ref) => FirestoreService());

/// Streams the per-app hour limits map for a given [uid].
final appLockLimitsProvider =
StreamProvider.family<Map<String, int>, String>((ref, uid) {
  final service = ref.read(firestoreServiceProvider);
  return service.watchAppLockLimits(uid);
});

/// Streams the last-week usage as a List of {label, value} maps.
final lastWeekUsageProvider =
StreamProvider.family<List<Map<String, dynamic>>, String>((ref, uid) {
  final service = ref.read(firestoreServiceProvider);
  return service.watchLastWeekUsage(uid);
});

/// Loads today’s summary (focusTime & tasksCompleted) once.
final dailySummaryProvider =
FutureProvider.family<DailySummary, String>((ref, uid) {
  final service = ref.read(firestoreServiceProvider);
  return service.fetchDailySummary(uid);
});

/// Streams the list of completed TaskModel objects for [uid].
final completedTasksProvider =
StreamProvider.family<List<TaskModel>, String>((ref, uid) {
  final service = ref.read(firestoreServiceProvider);
  return service.watchCompletedTasks(uid);
});