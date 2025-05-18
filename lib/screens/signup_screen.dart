import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Color & style constants (same as login—consider moving to a shared file)
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

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  DateTime? _dob;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _dob == null) {
      // Just show the SnackBar and return early
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select your birth date.'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      // Create the Firebase user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      // Optionally, update displayName
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(_name.text.trim());

      // After signup, send them to the dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup failed")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 18),
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked != null && mounted) setState(() => _dob = picked);
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
                      child:
                      const Icon(Icons.close, color: _kAccentGreen, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title + subtitle
                const Text("Sign Up", style: _kTitleStyle),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: RichText(
                    text: TextSpan(
                      text: "Already registered? ",
                      style: _kLinkStyle,
                      children: [
                        TextSpan(text: "Sign in", style: _kLinkBoldStyle)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _name,
                          decoration:
                          _decoration("Name", Icons.person_outline),
                          validator: (v) =>
                          v != null && v.trim().isNotEmpty ? null : "Required.",
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _email,
                          decoration:
                          _decoration("Email", Icons.mail_outline),
                          validator: (v) =>
                          v != null && v.contains("@") ? null : "Invalid email.",
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _password,
                          decoration:
                          _decoration("Password", Icons.lock_outline),
                          obscureText: true,
                          validator: (v) => v != null && v.length >= 6
                              ? null
                              : "Min 6 chars.",
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: InkWell(
                          onTap: _loading ? null : _pickDate,
                          child: InputDecorator(
                            decoration: _decoration(
                                "Date of Birth", Icons.calendar_today),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dob == null
                                      ? "Select"
                                      : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _dob == null
                                        ? Colors.black45
                                        : Colors.black,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
