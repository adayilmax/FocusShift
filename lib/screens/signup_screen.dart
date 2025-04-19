import 'package:flutter/material.dart';

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

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  DateTime? _dob;

  void _submit() {
    if (_formKey.currentState!.validate() && _dob != null) {
      // TODO: your signup logic…
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // show an error/snackbar
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
    if (picked != null) setState(() => _dob = picked);
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

                // Title + subtitle
                Text("Sign Up", style: _kTitleStyle),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator
                      .pushReplacementNamed(context, '/login'),
                  child: RichText(
                    text: TextSpan(
                      text: "Already registered? ",
                      style: _kLinkStyle,
                      children: [
                        TextSpan(
                            text: "Sign in", style: _kLinkBoldStyle)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // (Optional illustration goes here)
                // SizedBox(
                //   height: 120,
                //   child: Image.asset('assets/auth_illustration.png'),
                // ),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _name,
                          decoration: _decoration(
                              "Name", Icons.person_outline),
                          validator: (v) =>
                              v != null && v.trim().isNotEmpty
                                  ? null
                                  : "Required.",
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: TextFormField(
                          controller: _email,
                          decoration: _decoration(
                              "Email", Icons.mail_outline),
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
                          decoration: _decoration(
                              "Password", Icons.lock_outline),
                          obscureText: true,
                          validator: (v) =>
                              v != null && v.length >= 6
                                  ? null
                                  : "Min 6 chars.",
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: _kFieldHeight,
                        child: InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: _decoration(
                                "Date of Birth", Icons.calendar_today),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                Icon(Icons.arrow_forward_ios,
                                    size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        height: _kFieldHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: _kAccentGreen,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
