// lib/pages/profile/about_me_page.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // untuk memutar video

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // VIDEO DIAMBIL DARI ASSET
    // pastikan path sama dengan yang kamu tulis di pubspec.yaml
    _controller = VideoPlayerController.asset(
      'assets/videos/profile_intro.mp4',
    )
      ..initialize().then((_) {
        // video sudah siap diputar
        setState(() {
          _isInitialized = true;
        });
      });

    // kalau mau auto play, boleh tambahkan:
    // _controller.setLooping(true);
    // _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose(); // jangan lupa dibersihkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== VIDEO DI BAGIAN ATAS ======
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_controller),
                        // tombol play/pause di tengah video
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          child: Container(
                            color: Colors.black26,
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            const SizedBox(height: 24),

            // ====== PERKENALAN ======
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tentang Pengembang',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Aplikasi ini dikembangkan sebagai proyek mata kuliah, '
              'dengan tujuan untuk melatih kemampuan pengembangan aplikasi mobile '
              'menggunakan Flutter.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // CARD GHIELBRANT
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  child: Text('G'),
                ),
                title: Text('Ghielbrant'),
                subtitle: Text('NIM : 12230154'),
              ),
            ),
            const SizedBox(height: 12),

            // CARD ACEL
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  child: Text('A'),
                ),
                title: Text('Acel'),
                subtitle: Text('NIM : 124230100'),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Terima kasih sudah menggunakan aplikasi kami. '
              'Semoga aplikasi ini bermanfaat dan bisa terus dikembangkan '
              'lebih lanjut di masa depan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
