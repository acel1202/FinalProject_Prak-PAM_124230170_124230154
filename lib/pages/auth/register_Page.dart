// lib/pages/auth/register_page.dart

import 'package:flutter/material.dart';
import '../../db/user_model.dart';
import '../../manager/hive_user_manager.dart';
import '../utils/shared_prefs_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _errorText;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorText = 'Semua field wajib diisi';
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorText = 'Password dan konfirmasi tidak sama';
        _isLoading = false;
      });
      return;
    }

    final usernameTaken = await HiveUserManager.usernameExists(username);

    if (usernameTaken) {
      setState(() {
        _errorText = 'Username sudah digunakan';
        _isLoading = false;
      });
      return;
    }

    final user = AppUser(username: username, email: email, password: password);

    await HiveUserManager.addUser(user);

    await SharedPrefsHelper.setLoggedIn(true);
    await SharedPrefsHelper.setUserInfo(
      username: user.username,
      email: user.email,
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/main");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF4E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 86, color: Color(0xffFFB45F)),
              const SizedBox(height: 20),

              const Text(
                "Buat Akun Baru",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildInput(
                      controller: _usernameController,
                      label: "Username",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),

                    buildInput(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    buildPassword(
                      controller: _passwordController,
                      label: "Password",
                      visible: _passwordVisible,
                      onToggle: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                    const SizedBox(height: 20),

                    buildPassword(
                      controller: _confirmPasswordController,
                      label: "Konfirmasi Password",
                      visible: _confirmPasswordVisible,
                      onToggle: () => setState(
                        () =>
                            _confirmPasswordVisible = !_confirmPasswordVisible,
                      ),
                    ),

                    if (_errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFFB45F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        LoginPage.routeName,
                      ),
                      child: const Text(
                        "Sudah punya akun? Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF8A3D),
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
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? type,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget buildPassword({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
