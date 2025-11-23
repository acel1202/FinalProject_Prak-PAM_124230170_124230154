import 'package:flutter/material.dart';
import '../dashboard/home_page.dart';
// Import DiscoveryPage yang baru
import '../dashboard/discover_page.dart';

// Placeholder untuk halaman Profile (Biarkan saja jika belum diimplementasi)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Profile',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan.
  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const DiscoveryPage(), // Menggunakan DiscoveryPage yang baru
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan skema warna yang sesuai dengan Colors.orange
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,

      // Menampilkan halaman yang dipilih
      body: _pages[_selectedIndex],

      // Floating Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36.0),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Tombol Home
              _buildNavItem(
                icon: Icons.home_filled,
                label: 'Home',
                index: 0,
                primaryColor: primaryColor,
              ),
              // Tombol Discovery/Search
              _buildNavItem(
                icon: Icons.search,
                label: 'Discovery',
                index: 1,
                primaryColor: primaryColor,
              ),
              // Tombol Profile
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 2,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk membangun setiap item navigasi
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryColor,
  }) {
    final bool isSelected = index == _selectedIndex;

    // Memberikan efek background di item yang dipilih
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 24.0,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
