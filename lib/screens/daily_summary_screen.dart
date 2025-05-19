import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailySummaryScreen extends StatefulWidget {
  const DailySummaryScreen({super.key});

  @override
  State<DailySummaryScreen> createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {
  final TextEditingController _noteController = TextEditingController();

  String get todayStr {
    final today = DateTime.now();
    return "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  }

  Future<DocumentSnapshot> getSummary(String userId) {
    return FirebaseFirestore.instance
        .collection('daily_summaries')
        .doc("$userId-$todayStr")
        .get();
  }

  Future<void> saveSummary(String userId, int completed, int total, String note) async {
    await FirebaseFirestore.instance
        .collection('daily_summaries')
        .doc("$userId-$todayStr")
        .set({
      'userId': userId,
      'date': todayStr,
      'completedTasks': completed,
      'totalTasks': total,
      'note': note,
    });
  }

  Future<Map<String, int>> getTaskStats(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: todayStr)
        .get();
    final total = snapshot.docs.length;
    final completed = snapshot.docs.where((doc) => doc['completed'] == true).length;
    return {'total': total, 'completed': completed};
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Giriş yapmadınız"));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Günlük Özet")),
      body: FutureBuilder(
        future: Future.wait([
          getSummary(user.uid),
          getTaskStats(user.uid),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final DocumentSnapshot summaryDoc = snapshot.data![0] as DocumentSnapshot;
          final taskStats = snapshot.data![1] as Map<String, int>;
          final alreadySaved = summaryDoc.exists;
          final note = alreadySaved ? summaryDoc['note'] as String : '';
          _noteController.text = note;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Tamamlanan: ${taskStats['completed']} / ${taskStats['total']}"),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: "Bugünkü notunuz"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: alreadySaved
                      ? null
                      : () async {
                    await saveSummary(
                      user.uid,
                      taskStats['completed']!,
                      taskStats['total']!,
                      _noteController.text.trim(),
                    );
                    setState(() {}); // ekranı yenile
                  },
                  child: Text(alreadySaved ? "Özet Kaydedildi" : "Kaydet"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}