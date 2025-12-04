// lib/pages/booking/hotel/search_hotel.dart

import 'package:flutter/material.dart';
import '../../../manager/hotel_manager.dart';
import 'booking_hotel.dart';

class SearchHotelPage extends StatefulWidget {
  const SearchHotelPage({super.key});

  @override
  State<SearchHotelPage> createState() => _SearchHotelPageState();
}

class _SearchHotelPageState extends State<SearchHotelPage> {
  List<Hotel> _allHotels = [];
  List<Hotel> _foundHotels = [];

  @override
  void initState() {
    super.initState();
    _allHotels = getAllHotels();
    _foundHotels = _allHotels;
  }

  void _runFilter(String query) {
    List<Hotel> results = [];
    if (query.isEmpty) {
      results = _allHotels;
    } else {
      results = _allHotels
          .where(
            (h) =>
                h.name.toLowerCase().contains(query.toLowerCase()) ||
                h.city.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    setState(() => _foundHotels = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEF7F3),
      body: Column(
        children: [
          // ========================= HEADER =========================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== BACK BUTTON =====
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Cari Hotel",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ===== SEARCH BAR =====
                TextField(
                  onChanged: _runFilter,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    hintText: "Cari hotel atau kota...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ========================= LIST HOTEL =========================
          Expanded(
            child: _foundHotels.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada hotel ditemukan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _foundHotels.length,
                    itemBuilder: (_, index) =>
                        _buildHotelCard(_foundHotels[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel h) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingHotelPage(hotel: h)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.network(
                h.imageUrls.first,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // DETAILS
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(h.city, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        h.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    h.price,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingHotelPage(hotel: h),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Lihat Detail"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
