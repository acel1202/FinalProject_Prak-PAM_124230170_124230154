// lib/pages/screen/main_screen.dart

import 'package:flutter/material.dart';
import '../dashboard/home_page.dart';
import '../dashboard/discover_page.dart';
import '../profile/profile_page.dart'; // ✅ pakai ProfilePage yang asli

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  // optional, kalau mau dipakai untuk routes juga
  static const routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // di sini kita isi list halaman yang akan ditampilkan di bottom nav
    _pages = <Widget>[
      const HomePage(),
      const DiscoveryPage(),
      const ProfilePage(
        // TODO: nanti ganti dengan data dari Hive / SharedPrefs
        name: 'Ghielbrant',
        email: 'ghielbrant@example.com',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,

      // Halaman yang sedang dipilih
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
              _buildNavItem(
                icon: Icons.home_filled,
                label: 'Home',
                index: 0,
                primaryColor: primaryColor,
              ),
              _buildNavItem(
                icon: Icons.search,
                label: 'Discovery',
                index: 1,
                primaryColor: primaryColor,
              ),
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

  // Widget pembantu item nav
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryColor,
  }) {
    final bool isSelected = index == _selectedIndex;

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
