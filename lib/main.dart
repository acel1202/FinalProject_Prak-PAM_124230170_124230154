// lib/main.dart (KODE LENGKAP DIPERBAIKI)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk SystemChrome
import 'pages/screen/main_screen.dart'; // Atau entry point aplikasi Anda

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set orientasi aplikasi hanya potrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ================== TEMA WARNA BARU ==================
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFFFFB45F,
          ), // Warna utama dari Material Theme Builder
          primary: const Color(0xFFFFB45F), // Primary color
          onPrimary: const Color(0xFFFFFFFF), // Warna teks di atas primary
          secondary: const Color(
            0xFF755940,
          ), // Secondary color (contoh dari generator)
          onSecondary: const Color(0xFFFFFFFF),
          tertiary: const Color(
            0xFF6B613A,
          ), // Tertiary color (contoh dari generator)
          onTertiary: const Color(0xFFFFFFFF),
          error: const Color(0xFFBA1A1A), // Error color
          onError: const Color(0xFFFFFFFF),
          background: const Color(0xFFFFF8F5), // Background color
          onBackground: const Color(0xFF201A17),
          surface: const Color(0xFFFFF8F5), // Surface color
          onSurface: const Color(0xFF201A17),
        ),
        useMaterial3: true,
        fontFamily: 'Inter', // Sesuaikan jika Anda mengimpor font Inter
        // PERBAIKAN #1: Tambahkan const pada AppBarTheme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB45F), // Warna AppBar mengikuti primary
          foregroundColor: Colors.white, // Warna teks di AppBar
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
