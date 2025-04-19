import 'package:flutter/material.dart';
import '../main.dart'; // Assuming AppColors, AppTextStyles, AppDimens are defined here or globally

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
              // --- LOG OUT BUTTON ADDED ---
              Divider(color: drawerItemColor.withOpacity(0.5)), // Optional divider using the adaptive color
              ListTile(
                leading: Icon(Icons.logout, color: drawerItemColor), // Logout icon using adaptive color
                title: Text('Log Out', style: TextStyle(color: drawerItemColor)), // Logout text using adaptive color
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  // Navigate to root ('/') and remove all routes behind it
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                  // Add any actual logout logic here (e.g., clearing tokens, user state)
                },
              ),
              // --- LOG OUT BUTTON END ---
            ],
          ),
        ),
      ),
      // --- DRAWER UPDATES END ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        // Use the general text color for the title
        title: Text('Welcome Back', style: AppTextStyles.header.copyWith(color: generalTextColor)),
        iconTheme: IconThemeData(color: generalTextColor), // Ensure app bar icons (like drawer) match text color
        actions: [
          IconButton(
            // Use the general text color for the profile icon
            icon: Icon(Icons.account_circle, size: 28, color: generalTextColor),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: Padding(
        // Use AppDimens if defined, otherwise fallback
        padding: AppDimens.padding, // Assuming AppDimens.padding exists
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Keep button color as is
                foregroundColor: Colors.black,      // Keep button text color as is
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text("Focus Now"),
            ),
            SizedBox(height: 16),
            // Use general text color for headers
            Text("Daily Schedule", style: AppTextStyles.header.copyWith(color: generalTextColor)), // Assuming AppTextStyles.header exists
            Divider(color: Colors.green), // Keep divider green
            ...schedule.map((item) => ListTile(
              // Use general text color for time
              leading: Text(item['time'], style: TextStyle(fontWeight: FontWeight.bold, color: generalTextColor)),
              title: Row(
                children: [
                  // Ensure avatar text contrasts with avatar background
                  ...item['avatars'].map<Widget>((a) => CircleAvatar(radius: 12, child: Text(a, style: TextStyle(color: Colors.black)))).toList(), // Assuming light avatar background
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent, // Keep task background color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item['task'], style: TextStyle(color: Colors.black)), // Keep task text color
                  )
                ],
              ),
            )),
            SizedBox(height: 16),
            // Use general text color for headers
            Text("Today's Tasks", style: AppTextStyles.header.copyWith(color: generalTextColor)), // Assuming AppTextStyles.header exists
            Divider(color: Colors.green), // Keep divider green
            ...tasks.asMap().entries.map((entry) {
              int index = entry.key + 1;
              var task = entry.value;
              return ListTile(
                // Use general text color for index
                leading: Text("$index", style: TextStyle(fontWeight: FontWeight.bold, color: generalTextColor)),
                title: Row(
                  children: [
                    // Ensure avatar text contrasts with avatar background
                    ...task['avatars'].map<Widget>((a) => CircleAvatar(radius: 12, child: Text(a, style: TextStyle(color: Colors.black)))).toList(), // Assuming light avatar background
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent, // Keep task background color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(task['title'], style: TextStyle(color: Colors.black)), // Keep task text color
                    )
                  ],
                ),
                // Use general text color (with opacity) for subtitle
                subtitle: Text("Notes: ${task['note']}", style: TextStyle(color: generalTextColor.withOpacity(0.7))),
              );
            }).toList(),
            ListTile(
              // Keep add task button green (using greenAccent like your header now)
              leading: Icon(Icons.add_circle, color: Colors.greenAccent),
              title: Text("Add New Task", style: TextStyle(color: Colors.greenAccent)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}