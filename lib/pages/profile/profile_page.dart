import 'package:flutter/material.dart';

import '../utils/shared_prefs_helper.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await SharedPrefsHelper.clearAll();

    if (!context.mounted) return;

    // Habis logout balik ke login, hapus semua route sebelumnya
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Di sini kamu bisa tampilkan data user dari SharedPrefs kalau mau
            const Text(
              'Informasi Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Tombol logout
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
            