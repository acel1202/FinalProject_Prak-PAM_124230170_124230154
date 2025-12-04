// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../db/user_model.dart';
import '../auth/login_page.dart';
import '../utils/shared_prefs_helper.dart';
import 'about_me_page.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load username & email dari SharedPreferences
  Future<void> _loadUserData() async {
    final savedName = await SharedPrefsHelper.getUsername();
    final savedEmail = await SharedPrefsHelper.getEmail();

    setState(() {
      _name = savedName ?? "User";
      _email = savedEmail ?? "email@example.com";
    });
  }

  // Fungsi logout
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await SharedPrefsHelper.clearAll();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
      (route) => false,
    );
  }

  // ----- EDIT PROFIL -----
  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, String>?>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfilePage(initialName: _name, initialEmail: _email),
      ),
    );

    // kalau user menekan "Simpan"
    if (result != null && mounted) {
      final newName = result['name']?.trim() ?? _name;
      final newEmail = result['email']?.trim() ?? _email;

      // 1. update data user di Hive (untuk login pakai username baru)
      await _updateUserInHive(
        oldUsername: _name,
        newUsername: newName,
        newEmail: newEmail,
      );

      // 2. update SharedPreferences (untuk profil yang sedang login)
      await SharedPrefsHelper.setUsername(newName);
      await SharedPrefsHelper.setEmail(newEmail);

      // 3. update tampilan di layar profil
      setState(() {
        _name = newName;
        _email = newEmail;
      });
    }
  }

  // Update user di Hive berdasarkan username lama
  Future<void> _updateUserInHive({
    required String oldUsername,
    required String newUsername,
    required String newEmail,
  }) async {
    // TODO: ganti 'users_box' dengan NAMA BOX yang kamu pakai di register/login
    final box = await Hive.openBox<AppUser>('users_box');

    final users = box.values.toList();
    final index = users.indexWhere((user) => user.username == oldUsername);

    if (index == -1) {
      // kalau user tidak ketemu, tidak perlu apa-apa
      return;
    }

    final oldUser = users[index];

    final updatedUser = AppUser(
      username: newUsername,
      email: newEmail,
      password: oldUser.password, // password tetap
    );

    await box.putAt(index, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : "?";

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Avatar inisial
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nama
            Text(
              _name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Email
            Text(
              _email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // ===== MENU =====
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profil"),
              subtitle: const Text("Ubah nama dan email kamu"),
              onTap: _goToEditProfile,
            ),
            const Divider(height: 0),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About Me"),
              subtitle: const Text("Tentang pembuat aplikasi"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutMePage(),
                  ),
                );
              },
            ),
            const Divider(height: 0),

            const SizedBox(height: 24),

            // ===== LOGOUT =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
