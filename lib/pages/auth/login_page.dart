// lib/page/login_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/auth_service.dart';
import '../page/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  // 💡 KEMBALI: Controller untuk Email
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    // Ambil Email dan Password
    final email = _emailController.text.trim(); 
    final password = _passwordController.text.trim();

    try {
      // Panggil fungsi signInWithEmailPassword
      await _authService.signInWithEmailPassword(email, password); 
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 💡 KEMBALI: Input Email
          TextField(
            controller: _emailController, 
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Input Password
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: login, child: const Text('Login')),

          // Tombol ke halaman registrasi dengan logika pesan feedback
          TextButton(
            onPressed: () async {
              // Menunggu hasil (pesan) dari RegisterPage
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );

              // Jika hasil yang dikembalikan adalah String, tampilkan di Snackbar
              if (result is String && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            },
            child: const Text('Belum punya akun? Daftar di sini'),
          ),
        ],
      ),
    );
  }
}