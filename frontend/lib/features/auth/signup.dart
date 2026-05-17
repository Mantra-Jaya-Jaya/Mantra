import 'package:flutter/material.dart';
import 'signup2.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  String? _emailError;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      // Validate Email (simple regex)
      if (email.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
        _emailError = "Format email tidak valid";
      } else {
        _emailError = null;
      }

      // Validate Username
      if (username.isNotEmpty && username.length < 3) {
        _usernameError = "Username minimal 3 karakter";
      } else {
        _usernameError = null;
      }

      // Validate Password
      if (password.isNotEmpty && password.length < 8) {
        _passwordError = "Password minimal 8 karakter";
      } else {
        _passwordError = null;
      }

      _isFormValid = email.isNotEmpty && _emailError == null &&
                     username.isNotEmpty && _usernameError == null &&
                     password.isNotEmpty && _passwordError == null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB45309),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Header Logo
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo_putih_notext.png', // Logo icon MANTRA
                            width: 80,
                          ),
                          const Text(
                            'MANTRA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Container Putih Penuh ke Bawah
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepItem("1", "Create Account", true),
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                _buildStepItem(
                                  "2",
                                  "Fill Your Identity",
                                  false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Email',
                              errorText: _emailError,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              hint: 'Username',
                              errorText: _usernameError,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Password',
                              isPassword: true,
                              errorText: _passwordError,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isFormValid
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Signup2(
                                              email: _emailController.text,
                                              username: _usernameController.text,
                                              password: _passwordController.text,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFormValid
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFFCBD5E1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(), // Dorong tulisan login ke paling bawah
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem(String number, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive
              ? const Color(0xFFB45309)
              : Colors.grey[300],
          child: Text(
            number,
            style: TextStyle(color: isActive ? Colors.white : Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFFB45309) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB45309)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB45309)),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
      ),
    );
  }
}
