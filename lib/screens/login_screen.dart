import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Color & style constants
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
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // invalid inputs
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Invalid Form"),
          content: const Text("Please fix the errors before submitting."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _kFieldBorder),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: _kFieldBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                    const Text("FocusShift", style: _kLogoStyle),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: _kAccentGreen, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                const Text("Login", style: _kTitleStyle),
                const SizedBox(height: 32),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _email,
                          decoration: _decoration("Email", Icons.mail_outline),
                          validator: (v) =>
                          v != null && v.contains("@") ? null : "Invalid email.",
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _password,
                          decoration: _decoration("Password", Icons.lock_outline),
                          obscureText: true,
                          validator: (v) =>
                          v != null && v.length >= 6 ? null : "Minimum 6 characters.",
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: _kFieldHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kAccentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.black)
                              : const Icon(Icons.arrow_forward, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: implement password reset flow
                    },
                    child: const Text("Forgot Password?", style: _kLinkStyle),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: _kLinkStyle,
                        children: [
                          TextSpan(text: "Sign Up", style: _kLinkBoldStyle),
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
