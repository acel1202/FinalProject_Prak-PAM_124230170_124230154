// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
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

  Future<void> _loadUserData() async {
    final savedName = await SharedPrefsHelper.getUsername();
    final savedEmail = await SharedPrefsHelper.getEmail();

    setState(() {
      _name = savedName ?? "User";
      _email = savedEmail ?? "email@example.com";
    });
  }

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

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, String>?>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfilePage(initialName: _name, initialEmail: _email),
      ),
    );

    if (result != null && mounted) {
      final newName = result['name']?.trim() ?? _name;
      final newEmail = result['email']?.trim() ?? _email;

      await SharedPrefsHelper.setUserInfo(username: newName, email: newEmail);

      setState(() {
        _name = newName;
        _email = newEmail;
      });
    }
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
            Text(
              _name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(_email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Divider(),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutMePage()),
                );
              },
            ),
            const Divider(height: 0),
            const SizedBox(height: 24),
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
