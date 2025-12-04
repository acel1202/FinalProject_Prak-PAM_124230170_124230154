// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'about_me_page.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  // sementara, data nama & email dikirim lewat constructor
  final String name;
  final String email;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    // simpan nilai awal dari widget ke variabel lokal
    _name = widget.name;
    _email = widget.email;
  }

  // TODO: sesuaikan dengan cara logout di project kamu
  void _logout(BuildContext context) {
    // sementara hanya kasih snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout ditekan (isi logika logout kamu).')),
    );
  }

  // buka halaman edit profile dan tunggu hasilnya
  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, String>?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          initialName: _name,
          initialEmail: _email,
        ),
      ),
    );

    // kalau user menekan "Simpan", EditProfilePage akan mengirim data balik
    if (result != null && mounted) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ambil inisial dari nama (kalau kosong, pakai '?')
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // ====== "FOTO" PROFIL SEMENTARA (INISIAL) ======
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

          // ====== NAMA & EMAIL ======
          Text(
            _name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _email,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // isi di bawah dibuat scrollable
          Expanded(
            child: ListView(
              children: [
                // ====== EDIT PROFILE ======
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  subtitle: const Text('Ubah nama dan email kamu'),
                  onTap: _goToEditProfile,
                ),
                const Divider(height: 0),

                // ====== ABOUT ME ======
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Me'),
                  subtitle:
                      const Text('Tentang pengembang aplikasi ini'),
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
              ],
            ),
          ),

          // ====== LOGOUT DI PALING BAWAH ======
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
