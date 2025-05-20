import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/event_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  Future<void> _showAddEventDialog() async {
    final _formKey = GlobalKey<FormState>();
    final timeController = TextEditingController();
    final titleController = TextEditingController();
    DateTime selectedDate = selectedDay;

    final newEvent = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time (e.g. 13:00)'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter time' : null,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        setState(() {});
                      }
                    },
                    child: Text("Select Date: ${selectedDate.toLocal().toString().split(' ')[0]}")
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'time': timeController.text,
                    'title': titleController.text,
                    'date': selectedDate,
                  });
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );

    if (newEvent != null) {
      await Provider.of<EventProvider>(context, listen: false).addEvent(
        newEvent['date'],
        newEvent['time'],
        newEvent['title'],
      );
    }
  }

  Future<void> _showEditEventDialog(Event event) async {
    final _formKey = GlobalKey<FormState>();
    final timeController = TextEditingController(text: event.time);
    final titleController = TextEditingController(text: event.title);
    DateTime selectedDate = Provider.of<EventProvider>(context, listen: false).selectedDate;

    final edited = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time (e.g. 13:00)'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter time' : null,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        setState(() {});
                      }
                    },
                    child: Text("Change Date: ${selectedDate.toLocal().toString().split(' ')[0]}")
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'time': timeController.text,
                    'title': titleController.text,
                    'date': selectedDate,
                  });
                }
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );

    if (edited != null) {
      await Provider.of<EventProvider>(context, listen: false).updateEvent(
        id: event.id,
        newDate: edited['date'],
        newTime: edited['time'],
        newTitle: edited['title'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final events = provider.getEventsForDay(selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
              provider.updateSelectedDate(selected);
            },
          ),
          const Divider(),
          provider.isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
            child: events.isEmpty
                ? const Center(child: Text("No events for this day."))
                : ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final e = events[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(e.title),
                    subtitle: Text(e.time),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditEventDialog(e),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.removeEvent(e.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: OutlinedButton.icon(
              onPressed: _showAddEventDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add a new event"),
            ),
          )
        ],
      ),
    );
  }
}