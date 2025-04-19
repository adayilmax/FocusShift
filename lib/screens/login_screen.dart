import 'package:flutter/material.dart';

/// Color & style constants (you can also move these to a shared file)
const Color _kAccentGreen = Color(0xFF00FFD1);
const Color _kFieldBorder = Colors.black;
const double _kCardRadius = 24.0;
const double _kEdgePadding = 24.0;
const double _kFieldHeight = 54.0;
const TextStyle _kLogoStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const TextStyle _kTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const TextStyle _kLinkStyle = TextStyle(
  fontSize: 14,
  color: Colors.black54,
);
const TextStyle _kLinkBoldStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: your login logic…
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _kFieldBorder),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: _kFieldBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_kEdgePadding),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_kCardRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: _kEdgePadding,
              vertical: _kEdgePadding * 1.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("FocusShift", style: _kLogoStyle),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close,
                          color: _kAccentGreen, size: 28),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Title
                Text("Login", style: _kTitleStyle),
                SizedBox(height: 32),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _email,
                          decoration:
                              _decoration("Email", Icons.mail_outline),
                          validator: (v) =>
                              v != null && v.contains("@")
                                  ? null
                                  : "Invalid email.",
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _password,
                          decoration:
                              _decoration("Password", Icons.lock_outline),
                          obscureText: true,
                          validator: (v) =>
                              v != null && v.length >= 6
                                  ? null
                                  : "Minimum 6 characters.",
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        height: _kFieldHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kAccentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submit,
                          child: Icon(Icons.arrow_forward,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: forgot password
                    },
                    child: Text("Forgot Password?", style: _kLinkStyle),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator
                        .pushReplacementNamed(context, '/signup'),
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have account? ",
                        style: _kLinkStyle,
                        children: [
                          TextSpan(
                              text: "Sign Up", style: _kLinkBoldStyle)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
