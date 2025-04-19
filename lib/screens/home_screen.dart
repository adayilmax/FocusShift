import 'package:flutter/material.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home", style: AppTextStyles.header)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text("Navigation", style: AppTextStyles.header),
            ),
            ListTile(
              leading: Icon(Icons.login, color: AppColors.accent),
              title: Text("Login"),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: AppColors.accent),
              title: Text("Sign Up"),
              onTap: () => Navigator.pushNamed(context, '/signup'),
            ),
            ListTile(
              leading: Icon(Icons.list, color: AppColors.accent),
              title: Text("Card List"),
              onTap: () => Navigator.pushNamed(context, '/list'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.bolt, color: AppColors.accent),
              title: Text("Focus Mode"),
              onTap: () => Navigator.pushNamed(context, '/focus'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: AppColors.accent),
              title: Text("Schedule"),
              onTap: () => Navigator.pushNamed(context, '/schedule'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppDimens.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text("Login"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
