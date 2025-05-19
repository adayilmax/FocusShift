import 'package:flutter/material.dart';

class TodaysTaskScreen extends StatefulWidget {
  TodaysTaskScreen({super.key});

  @override
  State<TodaysTaskScreen> createState() => _TodaysTaskScreenState();
}

class _TodaysTaskScreenState extends State<TodaysTaskScreen> {
  int selectedDay = 18;

  // tasks içinde artık day, time, title, color var
  List<Map<String, dynamic>> tasks = [
    {'day': 18, 'time': '8:00 AM', 'title': 'Focus', 'color': Colors.green[400]},
    {'day': 18, 'time': '10:00 AM', 'title': 'Study', 'color': Colors.green[400]},
    {'day': 18, 'time': '12:00 PM', 'title': 'Research Business', 'color': Colors.green[400]},
    {'day': 19, 'time': '9:00 AM', 'title': 'Meeting', 'color': Colors.blue[400]},
    {'day': 20, 'time': '1:00 PM', 'title': 'Gym', 'color': Colors.red[400]},
  ];

  @override
  Widget build(BuildContext context) {
    // Seçili güne göre filtrele
    final dayTasks = tasks.where((task) => task['day'] == selectedDay).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Üst bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Tasks for August $selectedDay",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 18,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Tarih seçici butonlar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final day = 15 + index;
                  final isSelected = day == selectedDay;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: isSelected ? Colors.green : Colors.grey[300],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(day.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          _weekdayForDay(day),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Görev listesi (seçili günün)
            Expanded(
              child: ListView.builder(
                itemCount: dayTasks.length,
                itemBuilder: (context, index) {
                  final task = dayTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 70, child: Text(task['time'], style: const TextStyle(fontSize: 14))),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: task['color'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Text(
                              task['title'],
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Alt not
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "One step at a time. You'll get there.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),

      // Yeni görev ekleme butonu
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddTaskDialog();
        },
      ),
    );
  }

  // Haftanın günü örnek (15=Tue, vs.)
  String _weekdayForDay(int day) {
    // Basit örnek sabit günler
    const weekdays = ["Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    int index = day - 15;
    if (index < 0 || index >= weekdays.length) return "";
    return weekdays[index];
  }

  void _showAddTaskDialog() {
    TextEditingController _controller = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: "Enter task title"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Select time: "),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setStateDialog(() {
                            selectedTime = time;
                          });
                        }
                      },
                      child: Text(
                        selectedTime == null ? "Choose" : selectedTime!.format(context),
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  String newTask = _controller.text.trim();
                  if (newTask.isNotEmpty && selectedTime != null) {
                    String formattedTime = _formatTimeOfDay(selectedTime!);
                    setState(() {
                      tasks.add({
                        'day': selectedDay,
                        'time': formattedTime,
                        'title': newTask,
                        'color': Colors.green[400],
                      });
                      // Saat sırasına göre sırala
                      tasks.sort((a, b) => _parseTime(a['time']).compareTo(_parseTime(b['time'])));
                    });
                    Navigator.pop(context);
                  } else {
                    // Hata veya uyarı eklenebilir
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  DateTime _parseTime(String timeStr) {
    final format = timeStr.split(" ");
    final hm = format[0].split(":");
    int hour = int.parse(hm[0]);
    final int minute = int.parse(hm[1]);
    final period = format[1];

    if (period == "PM" && hour != 12) {
      hour += 12;
    } else if (period == "AM" && hour == 12) {
      hour = 0;
    }
    return DateTime(0, 0, 0, hour, minute);
  }
}
