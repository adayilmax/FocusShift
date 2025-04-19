import 'package:flutter/material.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home", style: AppTextStyles.header)),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Navigation", style: AppTextStyles.header),
            ),
            ListTile(
              title: Text("Login"),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            ListTile(
              title: Text("Sign Up"),
              onTap: () => Navigator.pushNamed(context, '/signup'),
            ),
            ListTile(
              title: Text("Card List"),
              onTap: () => Navigator.pushNamed(context, '/list'),
            ),
            ListTile(
              title: Text("Feature Screen"),
              onTap: () => Navigator.pushNamed(context, '/feature'),
            ),
          ],
        ),
      ),
      body: Center(
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
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/list'),
              child: Text("Card List"),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/feature'),
              child: Text("Feature Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
