import 'package:flutter/material.dart';
import 'pages/dashboard/home_page.dart';
import 'pages/screen/main_screen.dart'; // Import MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jet&Stay',
      theme: ThemeData(
        // Menggunakan seed color orange sesuai permintaan
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      // MENGUBAH: Menggunakan MainScreen sebagai halaman utama
      home: const MainScreen(),
    );
  }
}
