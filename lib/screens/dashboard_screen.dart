import 'package:flutter/material.dart';
import '../main.dart'; // Assuming AppColors, AppTextStyles, AppDimens are defined here or globally
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as myauth;

// Mock definitions if not available from main.dart for demonstration
class AppColors {
  static const Color primary = Colors.blue; // Example color
}

class AppTextStyles {
  static const TextStyle header = TextStyle(fontSize: 20, fontWeight: FontWeight.bold); // Example style
}

class AppDimens {
  static const EdgeInsets padding = EdgeInsets.all(16.0); // Example padding
}

class MainDashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schedule = [
    {"time": "8:00 AM", "task": "Focus", "avatars": ["A"]},
    {"time": "10:00 AM", "task": "Study", "avatars": ["B", "C"]},
    {"time": "12:00 PM", "task": "Research Business", "avatars": ["D"]}, // Corrected 12:00 AM to PM for midday
    {"time": "2:00 PM", "task": "Research Business", "avatars": ["E", "F"]}, // Corrected 14:00 PM to 2:00 PM
    {"time": "4:00 PM", "task": "Research Business", "avatars": ["G"]}, // Corrected 16:00 PM to 4:00 PM
  ];

  final List<Map<String, dynamic>> tasks = [
    {"title": "Focus", "note": "Work single", "avatars": ["A"]},
    {"title": "Research Business", "note": "Do research from the web", "avatars": ["B"]},
    {"title": "Focus", "note": "Work with group", "avatars": ["C", "D"]},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use a contrasting color for general text based on theme
    final generalTextColor = isDark ? Colors.white : Colors.black;
    // Define the green color for the drawer elements based on your update
    final drawerItemColor = isDark ? Colors.greenAccent : Colors.black; // Your adaptive color choice

    return Scaffold(
      // --- DRAWER UPDATES START ---
      drawer: Drawer(
        child: Container(
          // Keep the drawer background adaptive to the theme
          color: isDark ? Colors.grey[900] : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                // Use your updated DrawerHeader background color
                decoration: BoxDecoration(color: Colors.greenAccent),
                // Use your updated DrawerHeader text color
                child: Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24)),
              ),
              ListTile(
                // Use your adaptive color for icon and text
                leading: Icon(Icons.home, color: drawerItemColor),
                title: Text('Home', style: TextStyle(color: drawerItemColor)),
                onTap: () => Navigator.pop(context), // Close drawer
              ),
              ListTile(
                // Use your adaptive color for icon and text
                  leading: Icon(Icons.settings, color: drawerItemColor),
                  title: Text('Settings', style: TextStyle(color: drawerItemColor)),
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.pushNamed(context, '/settings');
                  }
              ),
              ListTile(
                // Use your adaptive color for icon and text
                  leading: Icon(Icons.lock, color: drawerItemColor),
                  title: Text('App Lock', style: TextStyle(color: drawerItemColor)),
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.pushNamed(context, '/applock');
                  }
              ),
              // Add Profile ListTile
              ListTile(
                // Use your adaptive color for icon and text
                leading: Icon(Icons.account_circle, color: drawerItemColor),
                title: Text('Profile', style: TextStyle(color: drawerItemColor)),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  Navigator.pushNamed(context, '/profile'); // Navigate to profile
                },
              ),

              // --- NEW DRAWER ITEMS ADDED ---
              ListTile(
                leading: Icon(Icons.list_alt_outlined, color: drawerItemColor), // Icon for Today's Tasks
                title: Text('Today\'s Tasks', style: TextStyle(color: drawerItemColor)),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  Navigator.pushNamed(context, '/todays_tasks'); // Navigate to today's tasks
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart_rounded, color: drawerItemColor), // Icon for Daily Summary
                title: Text('Daily Summary', style: TextStyle(color: drawerItemColor)),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  Navigator.pushNamed(context, '/daily_summary'); // Navigate to daily summary
                },
              ),
              ListTile(
                leading: Icon(Icons.bolt, color: drawerItemColor),
                title: Text("Focus Mode",style: TextStyle(color: drawerItemColor)),
                onTap: () => Navigator.pushNamed(context, '/focus'),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: drawerItemColor),
                title: Text("Schedule",style: TextStyle(color: drawerItemColor)),
                onTap: () => Navigator.pushNamed(context, '/schedule'),
              ),
              ListTile(
                leading: Icon(Icons.analytics_outlined, color: drawerItemColor),
                title: Text("Data Analytics",style: TextStyle(color: drawerItemColor)),
                onTap: () => Navigator.pushNamed(context, '/data_analytics'),
              ),
              // --- END NEW DRAWER ITEMS ---

              // --- LOG OUT BUTTON ---
              Divider(color: drawerItemColor.withOpacity(0.5)), // Optional divider using the adaptive color

              ListTile(
                leading: Icon(Icons.logout, color: drawerItemColor),
                title: Text('Log Out', style: TextStyle(color: drawerItemColor)),
                onTap: () async {
                  Navigator.pop(context); // Drawer'ı kapat
                  await Provider.of<myauth.AuthProvider>(context, listen: false).signOut();
                  // Yönlendirme gerekmez; AuthGate otomatik olarak login ekranına geçer
                },
              ),
              // --- LOG OUT BUTTON END ---
            ],
          ),
        ),
      ),
      // --- DRAWER UPDATES END ---

      // --- BODY SECTION (UNCHANGED from your provided code) ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Welcome Back', style: AppTextStyles.header.copyWith(color: generalTextColor)),
        iconTheme: IconThemeData(color: generalTextColor),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 28, color: generalTextColor),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {}, // Original onPressed
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text("Focus Now"),
            ),
            SizedBox(height: 16),
            Text("Daily Schedule", style: AppTextStyles.header.copyWith(color: generalTextColor)),
            Divider(color: Colors.green),
            ...schedule.map((item) => ListTile(
              leading: Text(item['time'], style: TextStyle(fontWeight: FontWeight.bold, color: generalTextColor)),
              title: Row(
                children: [
                  ...item['avatars'].map<Widget>((a) => CircleAvatar(radius: 12, child: Text(a, style: TextStyle(color: Colors.black)))).toList(),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item['task'], style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
              // No onTap added here, keeping original
            )),
            SizedBox(height: 16),
            Text("Today's Tasks", style: AppTextStyles.header.copyWith(color: generalTextColor)),
            Divider(color: Colors.green),
            ...tasks.asMap().entries.map((entry) {
              int index = entry.key + 1;
              var task = entry.value;
              return ListTile(
                leading: Text("$index", style: TextStyle(fontWeight: FontWeight.bold, color: generalTextColor)),
                title: Row(
                  children: [
                    ...task['avatars'].map<Widget>((a) => CircleAvatar(radius: 12, child: Text(a, style: TextStyle(color: Colors.black)))).toList(),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(task['title'], style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
                subtitle: Text("Notes: ${task['note']}", style: TextStyle(color: generalTextColor.withOpacity(0.7))),
                // No onTap added here, keeping original
              );
            }).toList(),
            ListTile( // Keep original Add New Task ListTile
              leading: Icon(Icons.add_circle, color: Colors.greenAccent),
              title: Text("Add New Task", style: TextStyle(color: Colors.greenAccent)),
              onTap: () {}, // Original onTap
            ),
          ],
        ),
      ),
      // --- END BODY SECTION ---
    );
  }
}