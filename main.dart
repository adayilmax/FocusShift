import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Main App Widget using MaterialApp with named routes.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation & UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Apply your custom font defined in pubspec.yaml here.
        fontFamily: 'CustomFont', 
      ),
      // Define the initial route and the named routes.
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/list': (context) => CardListScreen(),
        '/feature': (context) => FeatureScreen(),
      },
    );
  }
}

/// Utility Classes for Colors, TextStyles, and Paddings.
class AppColors {
  static const primary = Colors.blue;
  static const accent = Colors.orange;
}

class AppTextStyles {
  static const header = TextStyle(
    fontSize: 24,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );
  static const subHeader = TextStyle(
    fontSize: 18,
    color: Colors.black87,
    fontStyle: FontStyle.italic,
  );
}

class AppDimens {
  static const padding = EdgeInsets.all(16.0);
}

/// HomeScreen with Navigation Drawer and Navigation Buttons.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: AppTextStyles.header),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Navigation", style: AppTextStyles.header),
            ),
            ListTile(
              title: Text("Login"),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              title: Text("Sign Up"),
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
            ListTile(
              title: Text("Card List"),
              onTap: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
            ListTile(
              title: Text("Feature Screen"),
              onTap: () {
                Navigator.pushNamed(context, '/feature');
              },
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

/// Login Screen with a Form and Validation.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Validate and submit the form.
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If valid, process the login (here simply showing a SnackBar).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // If invalid, show an AlertDialog.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Form"),
          content: Text("Please fix the errors in red before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: AppTextStyles.header),
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email Field.
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required.";
                  }
                  if (!value.contains('@')) {
                    return "Invalid email address.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password Field.
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required.";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sign Up Screen with a Form and Validation.
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Validate and submit the sign-up form.
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If valid, process the signup (here simply showing a SnackBar).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing up...')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // If invalid, show an AlertDialog.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Form"),
          content: Text("Please correct the errors before signing up."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: AppTextStyles.header),
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field.
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Email Field.
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required.";
                  }
                  if (!value.contains('@')) {
                    return "Enter a valid email address.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password Field.
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required.";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple model class for list items.
class Item {
  final String title;
  final String description;

  Item({required this.title, required this.description});
}

/// CardListScreen that shows a list of items in Card widgets with delete actions.
class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  List<Item> items = List.generate(
    5,
    (index) => Item(
      title: 'Item ${index + 1}',
      description: 'Description for item ${index + 1}',
    ),
  );

  /// Remove an item from the list.
  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card & List", style: AppTextStyles.header),
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(items[index].title),
                subtitle: Text(items[index].description),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// FeatureScreen showcasing both a network and an asset image.
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feature Screen", style: AppTextStyles.header),
      ),
      body: Padding(
        padding: AppDimens.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Network Image.
            Image.network(
              'https://via.placeholder.com/300x150',
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Asset Image.
            // Ensure that you have the file "assets/images/sample.png" and update pubspec.yaml accordingly.
            Image.asset(
              'assets/images/sample.png',
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              "This screen showcases both network and asset images.",
              style: AppTextStyles.subHeader,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
