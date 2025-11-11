import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> sliderImages = [
    "https://images.unsplash.com/photo-1549880338-65ddcdfd017b",
    "https://images.unsplash.com/photo-1469474968028-56623f02e42e",
    "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.positions.isNotEmpty) {
        _currentPage = (_currentPage + 1) % sliderImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 10),

            /// TITLE
            Row(
              children: [
                const Text(
                  "Discover Places",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 26),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// AUTO SLIDER
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliderImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(sliderImages[index], fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Pyramid",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Egyptian Pyramids",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// LAYANAN TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Layanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Lihat semua",
                  style: TextStyle(fontSize: 14, color: Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// LAYANAN OPTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                layananCard(
                  title: "Booking Hotel",
                  icon: Icons.hotel,
                  gradient: [Colors.orange, Colors.deepOrange],
                ),
                layananCard(
                  title: "Booking Pesawat",
                  icon: Icons.flight_takeoff,
                  gradient: [Colors.blue, Colors.lightBlueAccent],
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                layananCard(
                  title: "Riwayat Hotel",
                  icon: Icons.history,
                  gradient: [Colors.purple, Colors.deepPurpleAccent],
                ),
                layananCard(
                  title: "Riwayat Tiket",
                  icon: Icons.receipt_long,
                  gradient: [Colors.green, Colors.lightGreen],
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget layananCard({
    required String title,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
