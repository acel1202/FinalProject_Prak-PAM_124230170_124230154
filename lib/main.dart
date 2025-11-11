import 'package:flutter/material.dart';
import 'pages/screen/main_screen.dart';

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
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB45F), // dari palette yang kamu kirim
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(), // ✅ HomePage masuk melalui MainScreen
    );
  }
}
