// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ==== IMPORT FILE PROJECTMU ====
// Sesuaikan path jika beda
import 'db/user_model.dart';
import 'pages/auth/splash_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_Page.dart';
import 'pages/dashboard/home_page.dart'; // dipakai hanya untuk routeName
import 'pages/screen/main_screen.dart'; // ✅ berisi bottom nav Home/Discovery/Profile

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Register adapter user (typeId harus sama dengan di user_model.dart)
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AppUserAdapter());
  }
  // Kalau kamu punya adapter Hive lain (pesawat/hotel), register juga di sini.

  // Set orientasi aplikasi hanya potrait
  await SystemChrome.setPreferredOrientations([
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB45F),
          primary: const Color(0xFFFFB45F),
          onPrimary: const Color(0xFFFFFFFF),
          secondary: const Color(0xFF755940),
          onSecondary: const Color(0xFFFFFFFF),
          tertiary: const Color(0xFF6B613A),
          onTertiary: const Color(0xFFFFFFFF),
          error: const Color(0xFFBA1A1A),
          onError: const Color(0xFFFFFFFF),
          background: const Color(0xFFFFF8F5),
          onBackground: const Color(0xFF201A17),
          surface: const Color(0xFFFFF8F5),
          onSurface: const Color(0xFF201A17),
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB45F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // ==== ROUTING APLIKASI ====
      // Mulai dari SplashPage untuk cek Hive / status login
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),

        // ⬇️ PENTING:
        // Route dengan nama HomePage.routeName sekarang mengarah ke MainScreen,
        // bukan langsung ke HomePage lagi, supaya bottom nav muncul.
        HomePage.routeName: (_) => const MainScreen(),
      },
    );
  }
}
