import 'package:flutter/material.dart';

// Simple Event data class
class Event {
  final String time;
  final String title;

  Event({required this.time, required this.title});
}

// --- Schedule Screen Widget ---
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<Event> events = [
    Event(time: '08:00', title: 'Morning Stand-up'),
    Event(time: '11:00', title: 'Client Meeting'),
    Event(time: '14:30', title: 'Project Sync'),
    Event(time: '17:00', title: 'Team Review'),
  ];

  // Method to remove an event and update state
  void _removeEvent(int index) {
    if (index < 0 || index >= events.length) return;

    final removedEvent = events[index];
    // Ensure mounted check *before* setState
    if (!mounted) return;
    setState(() {
      events.removeAt(index);
    });

    // Ensure mounted check *before* ScaffoldMessenger
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${removedEvent.title} removed.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // --- Function to show the Add Event Dialog ---
  Future<void> _showAddEventDialog() async {
    final _formKey = GlobalKey<FormState>();
    // Controllers are created locally and will be garbage collected.
    // DO NOT dispose them manually here as it causes errors.
    final _timeController = TextEditingController();
    final _titleController = TextEditingController();

    final currentContext = context; // Capture context before async gap

    final Event? newEvent = await showDialog<Event>(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    hintText: 'HH:MM (e.g., 09:30)',
                    icon: Icon(Icons.access_time),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                      return 'Use HH:MM format';
                    }
                    try {
                      final parts = value.split(':');
                      final hour = int.tryParse(parts[0]);
                      final minute = int.tryParse(parts[1]);
                      if (hour == null || minute == null) {
                        return 'Invalid number format';
                      }
                      if (hour < 0 || hour > 23) {
                        return 'Hour must be 0-23';
                      }
                      if (minute < 0 || minute > 59) {
                        return 'Minute must be 0-59';
                      }
                    } catch (e) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Event description',
                    icon: Icon(Icons.title),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final event = Event(
                    time: _timeController.text,
                    title: _titleController.text,
                  );
                  Navigator.of(dialogContext).pop(event);
                }
              },
            ),
          ],
        );
      },
    );

    // --- REMOVED controller dispose calls ---
    // _timeController.dispose(); // REMOVED
    // _titleController.dispose(); // REMOVED

    // --- Add event block ---
    if (!mounted) return; // Check if widget is still mounted

    if (newEvent != null) {
      setState(() {
        events.add(newEvent);
        events.sort((a, b) => a.time.compareTo(b.time));
      });

      // Show SnackBar *after* setState, still checking mounted status
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text('${newEvent.title} added.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  // --- End Dialog Function ---


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDark ? Colors.white : Colors.black87;
    final sundayColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // --- Column Layout ---
        child: Column(
          children: [
            // --- MODIFIED: Wrapped GridView in Flexible ---
            // 1) Calendar Grid Placeholder
            Flexible( // Allows GridView to shrink if needed, doesn't force Expanded height
              child: GridView.builder(
                shrinkWrap: true, // Still needed with Flexible in Column
                // physics: const NeverScrollableScrollPhysics(), // Not strictly needed if Flexible works
                itemCount: 31,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemBuilder: (context, i) {
                  final day = (i + 1);
                  final isSunday = (i % 7) == 6;
                  final isToday = day == DateTime.now().day;

                  return Container(
                    alignment: Alignment.center,
                    decoration: isToday ? BoxDecoration(
                        border: Border.all(color: colorScheme.primary, width: 1),
                        shape: BoxShape.circle
                    ) : null,
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSunday ? sundayColor : defaultTextColor,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            // --- END MODIFICATION ---

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // 2) Event List - Kept Expanded
            Expanded( // Takes remaining space after Flexible GridView and other fixed items
              child: ListView.separated(
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  if (i >= events.length) return const SizedBox.shrink();
                  final e = events[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Text(
                        e.time,
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                      title: Text(e.title),
                      trailing: IconButton(
                        tooltip: 'Delete Event',
                        icon: Icon(Icons.delete_outline, color: colorScheme.error),
                        onPressed: () => _removeEvent(i),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 3) Add Event Button Row (Stays at bottom)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add a new event'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                    ),
                    onPressed: _showAddEventDialog,
                  ),
                ),
              ],
            ),
          ],
        ),
        // --- End Column Layout ---
      ),
    );
  }
}