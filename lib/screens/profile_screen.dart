import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  bool _loading = true;
  String? _name;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _name = data['name'];
          _email = data['email'];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      print("❌ Error loading user data: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundImage: const AssetImage('assets/mock_images/default-avatar.png'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _name ?? 'Name not found',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Center(
            child: Text(
              _email ?? 'Email not found',
            ),
          ),
          const SizedBox(height: 24),
          sectionTitle(
            "General Settings",
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.cloud_sync, color: Colors.black),
            ),
            title: const Text("Sync Preferences"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          SwitchListTile(
            secondary: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.settings, color: Colors.black),
            ),
            title: const Text("Mode"),
            subtitle: const Text("Dark & Light"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() => isDarkMode = val);
              widget.onThemeChanged(val);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.key, color: Colors.black),
            ),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.language, color: Colors.black),
            ),
            title: const Text("Language"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 16),
          sectionTitle("Information"),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.phone_android, color: Colors.black),
            ),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.description, color: Colors.black),
            ),
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.shield, color: Colors.black),
            ),
            title: const Text("Privacy Policy and Safety"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.black),
            ),
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
