import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';
import 'login_screen.dart';

/// Simple Event data class
class Event {
  final String time;
  final String title;

  Event({required this.time, required this.title});
}

/// Schedule Screen with Firebase auth gating
class ScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = '/schedule';
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final List<Event> events = [
    Event(time: '08:00', title: 'Morning Stand-up'),
    Event(time: '11:00', title: 'Client Meeting'),
    Event(time: '14:30', title: 'Project Sync'),
    Event(time: '17:00', title: 'Team Review'),
  ];

  /// Remove event at [index] and show a SnackBar
  void _removeEvent(int index) {
    if (index < 0 || index >= events.length) return;
    final removed = events[index];
    setState(() {
      events.removeAt(index);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${removed.title} removed.'), duration: Duration(seconds: 2)),
      );
    }
  }

  /// Show dialog to add a new event
  Future<void> _showAddEventDialog() async {
    final formKey = GlobalKey<FormState>();
    final timeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();

    final newEvent = await showDialog<Event>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('Add New Event'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: timeCtrl,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    hintText: 'HH:MM (e.g., 09:30)',
                    icon: Icon(Icons.access_time),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter time';
                    final match = RegExp(r'^\d{2}:\d{2}$').firstMatch(val);
                    if (match == null) return 'Invalid format';
                    final parts = val.split(':');
                    final h = int.tryParse(parts[0]);
                    final m = int.tryParse(parts[1]);
                    if (h == null || m == null) return 'Invalid numbers';
                    if (h < 0 || h > 23) return 'Hour 0-23';
                    if (m < 0 || m > 59) return 'Minute 0-59';
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Event description',
                    icon: Icon(Icons.title),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Enter title' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(null),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogCtx).pop(
                    Event(time: timeCtrl.text, title: titleCtrl.text),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    // After dialog
    if (!mounted || newEvent == null) return;
    setState(() {
      events.add(newEvent);
      events.sort((a, b) => a.time.compareTo(b.time));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newEvent.title} added.'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    return auth.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
          return const Scaffold();
        }
        // Authenticated → show schedule
        return Scaffold(
          appBar: AppBar(title: const Text('Schedule')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Calendar grid
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 31,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                    ),
                    itemBuilder: (_, i) {
                      final day = i + 1;
                      final isSunday = (i % 7) == 6;
                      final isToday = day == DateTime.now().day;
                      final colorScheme = Theme.of(context).colorScheme;
                      return Container(
                        alignment: Alignment.center,
                        decoration: isToday
                            ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: colorScheme.primary, width: 1),
                        )
                            : null,
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color:
                            isSunday ? colorScheme.secondary : null,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Event list
                Expanded(
                  child: ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final e = events[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: Text(
                            e.time,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(e.title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline,
                                color:
                                Theme.of(context).colorScheme.error),
                            onPressed: () => _removeEvent(i),
                            tooltip: 'Delete Event',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 16),
                // Add event button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showAddEventDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Add a new event'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }
}
