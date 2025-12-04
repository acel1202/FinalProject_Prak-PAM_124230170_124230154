import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'db/user_model.dart';

// AUTH
import 'pages/auth/splash_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';

// DASHBOARD
import 'pages/dashboard/home_page.dart';
import 'pages/screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AppUserAdapter());
  }

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB45F)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),

      // MULAI DARI SPLASH
      initialRoute: SplashPage.routeName,

      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),

        // Sekarang HomePage benar-benar HomePage lagi
        HomePage.routeName: (_) => const HomePage(),

        // ROUTE MENUJU MAIN SCREEN SETELAH LOGIN
        "/main": (_) => const MainScreen(),
      },
    );
  }
}
