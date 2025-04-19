import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  final events = [
    {'time': '08:00', 'title': 'Meeting1'},
    {'time': '15:00', 'title': 'Meeting2'},
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(title: Text('Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Simple calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 31,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (_, i) {
                final day = (i + 1).toString();
                final isSunday = i % 7 == 0;
                return Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSunday ? Colors.green : Colors.black87,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),
            Divider(),

            // 2) Event list
            Expanded(
              child: ListView.separated(
                itemCount: events.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (_, i) {
                  final e = events[i];
                  return ListTile(
                    leading: Text(
                      e['time']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(e['title']!),
                  );
                },
              ),
            ),

            // 3) Add event button
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: open add‑event form
                    },
                    child: Text('add a new event'),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: accent,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
