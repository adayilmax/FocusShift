import 'package:flutter/material.dart';
import '../main.dart';

class MainDashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schedule = [
    {
      "time": "8:00 AM",
      "task": "Focus",
      "avatars": ["A"],
    },
    {
      "time": "10:00 AM",
      "task": "Study",
      "avatars": ["B", "C"],
    },
    {
      "time": "12:00 PM",
      "task": "Research Business",
      "avatars": ["D"],
    },
    {
      "time": "2:00 PM",
      "task": "Research Business",
      "avatars": ["E", "F"],
    },
    {
      "time": "4:00 PM",
      "task": "Research Business",
      "avatars": ["G"],
    },
  ];

  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Focus",
      "note": "Work single",
      "avatars": ["A"],
    },
    {
      "title": "Research Business",
      "note": "Do research from the web",
      "avatars": ["B"],
    },
    {
      "title": "Focus",
      "note": "Work with group",
      "avatars": ["C", "D"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    final accent = AppColors.accent;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 120,
              color: accent,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(16),
              child: Text(
                "Menu",
                style: AppTextStyles.header.copyWith(color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: generalTextColor),
                    title: Text(
                      "Home",
                      style: TextStyle(color: generalTextColor),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/dashboard'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: generalTextColor),
                    title: Text(
                      "Settings",
                      style: TextStyle(color: generalTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: generalTextColor),
                    title: Text(
                      "App Lock",
                      style: TextStyle(color: generalTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/applock');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: generalTextColor),
                    title: Text(
                      "Profile",
                      style: TextStyle(color: generalTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  Divider(color: generalTextColor.withOpacity(0.5)),
                  ListTile(
                    leading: Icon(Icons.bolt, color: accent),
                    title: Text("Focus Mode"),
                    onTap: () => Navigator.pushNamed(context, '/focus'),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today, color: accent),
                    title: Text("Schedule"),
                    onTap: () => Navigator.pushNamed(context, '/schedule'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: generalTextColor),
              title: Text("Log Out", style: TextStyle(color: generalTextColor)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: generalTextColor),
        title: Text(
          "Welcome Back",
          style: AppTextStyles.header.copyWith(color: generalTextColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: generalTextColor),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text("Focus Now"),
            ),
            SizedBox(height: 16),
            Text(
              "Daily Schedule",
              style: AppTextStyles.header.copyWith(color: generalTextColor),
            ),
            Divider(color: accent),
            ...schedule.map(
              (item) => ListTile(
                leading: Text(
                  item['time'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: generalTextColor,
                  ),
                ),
                title: Row(
                  children: [
                    ...item['avatars']
                        .map<Widget>(
                          (a) => CircleAvatar(
                            radius: 12,
                            child: Text(
                              a,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['task'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Today's Tasks",
              style: AppTextStyles.header.copyWith(color: generalTextColor),
            ),
            Divider(color: accent),
            ...tasks.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final t = entry.value;
              return ListTile(
                leading: Text(
                  "$idx",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: generalTextColor,
                  ),
                ),
                title: Row(
                  children: [
                    ...t['avatars']
                        .map<Widget>(
                          (a) => CircleAvatar(
                            radius: 12,
                            child: Text(
                              a,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        t['title'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  "Notes: ${t['note']}",
                  style: TextStyle(color: generalTextColor.withOpacity(0.7)),
                ),
              );
            }).toList(),
            ListTile(
              leading: Icon(Icons.add_circle, color: accent),
              title: Text("Add New Task", style: TextStyle(color: accent)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
