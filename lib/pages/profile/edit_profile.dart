// lib/pages/profile/edit_profile.dart

import 'package:flutter/material.dart';
import '../../manager/hive_user_manager.dart';
import '../../db/user_model.dart';
import '../utils/shared_prefs_helper.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _emailC;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.initialName);
    _emailC = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameC.text.trim();
    final newEmail = _emailC.text.trim();

    final oldUser = await HiveUserManager.getUserByUsername(widget.initialName);

    if (oldUser != null) {
      final updatedUser = AppUser(
        username: newName,
        email: newEmail,
        password: oldUser.password,
      );

      if (widget.initialName != newName) {
        await HiveUserManager.deleteUser(widget.initialName);
      }

      await HiveUserManager.addUser(updatedUser);

      await SharedPrefsHelper.setUserInfo(username: newName, email: newEmail);
    }

    Navigator.pop<Map<String, String>>(context, {
      'name': newName,
      'email': newEmail,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!v.contains('@')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
