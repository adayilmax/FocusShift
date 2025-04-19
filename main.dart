import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Main App Widget using MaterialApp with named routes.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusShift App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'CustomFont',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/list': (context) => CardListScreen(),
        '/feature': (context) => FeatureScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/timer': (context) => FocusTimerScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/todayTask': (context) => TodayTaskScreen(),
        '/summary': (context) => DailySummaryScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

/// Utility Classes
class AppTextStyles {
  static const header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const subHeader = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  );
}

class AppDimens {
  static const padding = EdgeInsets.all(16.0);
}

/// Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home', style: AppTextStyles.header)),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Navigation', style: AppTextStyles.header)),
            _buildDrawerItem(context, 'Login', '/login'),
            _buildDrawerItem(context, 'Sign Up', '/signup'),
            _buildDrawerItem(context, 'Card List', '/list'),
            _buildDrawerItem(context, 'Feature', '/feature'),
            _buildDrawerItem(context, 'Calendar', '/calendar'),
            _buildDrawerItem(context, 'Focus Timer', '/timer'),
            _buildDrawerItem(context, 'Dashboard', '/dashboard'),
            _buildDrawerItem(context, "Today's Task", '/todayTask'),
            _buildDrawerItem(context, 'Summary', '/summary'),
            _buildDrawerItem(context, 'Profile', '/profile'),
          ],
        ),
      ),
      body: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _NavButton(label: 'Login', route: '/login'),
            _NavButton(label: 'Sign Up', route: '/signup'),
            _NavButton(label: 'Card List', route: '/list'),
            _NavButton(label: 'Feature', route: '/feature'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String route;
  const _NavButton({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(label),
    );
  }
}

/// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  // ignore: unused_element
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = pickedDate.toString().split(' ')[0];
    }
  }

  Widget _buildField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return '$hint required';
          if (hint == 'Email' && !v.contains('@')) return 'Invalid email';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.green),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 16),
              Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(hint: 'Email', icon: Icons.email, controller: emailController),
                    SizedBox(height: 16),
                    _buildField(hint: 'Password', icon: Icons.lock, controller: passwordController, obscure: true),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submitForm,
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                ),
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Not registered yet? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Signup Screen
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing up...')),
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = pickedDate.toString().split(' ')[0];
    }
  }

  Widget _buildField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return '$hint required';
          if (hint == 'Email' && !v.contains('@')) return 'Invalid email';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.green),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 16),
              Text('Sign Up', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(hint: 'Name', icon: Icons.person, controller: nameController),
                    SizedBox(height: 16),
                    _buildField(hint: 'Email', icon: Icons.email, controller: emailController),
                    SizedBox(height: 16),
                    _buildField(hint: 'Password', icon: Icons.lock, controller: passwordController, obscure: true),
                    SizedBox(height: 16),
                    _buildField(
                      hint: 'Date of Birth',
                      icon: Icons.calendar_today,
                      controller: dobController,
                      readOnly: true,
                      onTap: _pickDate,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submitForm,
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already registered? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Card List Screen
class CardListScreen extends StatelessWidget {
  final List<String> items = List.generate(5, (i) => 'Item \${i+1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card List', style: AppTextStyles.header)),
      body: ListView.builder(
        padding: AppDimens.padding,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(items[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Feature Screen
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feature', style: AppTextStyles.header)),
      body: Padding(
        padding: AppDimens.padding,
        child: Column(
          children: [
            Image.network('https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
            SizedBox(height: 16),
            Text('This screen showcases network and asset images.', style: AppTextStyles.subHeader),
          ],
        ),
      ),
    );
  }
}

/// Calendar Screen Stub
class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar', style: AppTextStyles.header)),
      body: Center(child: Text('Calendar Screen Content')),
    );
  }
}

/// Focus Timer Screen Stub
class FocusTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Focus Timer', style: AppTextStyles.header)),
      body: Center(child: Text('Focus Timer Screen Content')),
    );
  }
}

/// Dashboard Screen Stub
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: AppTextStyles.header)),
      body: Center(child: Text('Dashboard Screen Content')),
    );
  }
}

/// Today's Task Screen Stub
class TodayTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Today's Task", style: AppTextStyles.header)),
      body: Center(child: Text("Today's Task Screen Content")),
    );
  }
}

/// Daily Summary Screen Stub
class DailySummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Summary', style: AppTextStyles.header)),
      body: Center(child: Text('Daily Summary Screen Content')),
    );
  }
}

/// Profile Screen Stub
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.header)),
      body: Center(child: Text('Profile Screen Content')),
    );
  }
}
