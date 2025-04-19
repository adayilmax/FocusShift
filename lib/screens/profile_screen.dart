import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundImage:
                  NetworkImage("https://i.pravatar.cc/150?img=3"),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Jonathan Patterson",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Center(
            child: Text("hello@reallygreatsite.com"),
          ),
          const SizedBox(height: 24),

          // ✅ Tıklanabilir General Settings başlığı
          sectionTitle(
            "General Settings",
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),

          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.cloud_sync, color: Colors.black),
            ),
            title: const Text("Sync Preferences"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),

          SwitchListTile(
            secondary: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.settings, color: Colors.black),
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
              child: Icon(Icons.key, color: Colors.black),
            ),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.language, color: Colors.black),
            ),
            title: const Text("Language"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),

          const SizedBox(height: 16),
          // ⬇️ Normal statik başlık (tıkanabilir değil)
          sectionTitle("Information"),

          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.phone_android, color: Colors.black),
            ),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.description, color: Colors.black),
            ),
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.shield, color: Colors.black),
            ),
            title: const Text("Privacy Policy and Safety"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  // ✅ Güncellenmiş: Tıklanabilir başlık fonksiyonu
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