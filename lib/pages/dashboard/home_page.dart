// lib/pages/dashboard/home_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finalproject_124230170_124230154/pages/booking/hotel/search_hotel.dart';
import 'package:finalproject_124230170_124230154/pages/booking/pesawat/search_flight.dart';

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

  final Color primary = const Color(0xFFFFB45F);
  final Color onPrimary = const Color(0xFF4F2800);

  final Color secondary = const Color(0xFF755A43);
  final Color tertiary = const Color(0xFF5D6236);

  final Color background = const Color(0xFFFEF7F3);
  final Color surface = const Color(0xFFFFF8F3);
  final Color surfaceVariant = const Color(0xFFF2E0D0);

  final Color outline = const Color(0xFF857469);
  final Color neutral = const Color(0xFF76736F);

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
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  "Discover Places",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
                const Spacer(),
                Icon(Icons.search, size: 26, color: neutral),
              ],
            ),

            const SizedBox(height: 14),

            // ==================== SLIDER ====================
            Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: sliderImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              sliderImages[index],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.65),
                                    Colors.black.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 22,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pyramid",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Egyptian Pyramids",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    Positioned(
                      top: 16,
                      right: 16,
                      child: ElevatedButton(
                        onPressed: () {
                          final next = (_currentPage + 1) % sliderImages.length;
                          _pageController.animateToPage(
                            next,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: surface.withOpacity(0.85),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Selanjutnya",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==================== LAYANAN ====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Layanan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  "Lihat semua",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: layananCard(
                        title: "Booking Hotel",
                        icon: Icons.hotel,
                        gradient: [primary, const Color(0xFFFFA23D)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingHotelPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: layananCard(
                        title: "Booking Pesawat",
                        icon: Icons.flight_takeoff,
                        gradient: [
                          const Color(0xFF7CB7FF),
                          const Color(0xFF4A9BFF),
                        ],
                        onTap: () {
                          // ❤️ Navigasi ke SearchFlightPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchFlightPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: layananCard(
                        title: "Riwayat Hotel",
                        icon: Icons.history,
                        gradient: [secondary, const Color(0xFF5E442F)],
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: layananCard(
                        title: "Riwayat Tiket",
                        icon: Icons.receipt_long,
                        gradient: [tertiary, const Color(0xFF4A4F2B)],
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget layananCard({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: outline.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
                fontFamily: "Inter",
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
