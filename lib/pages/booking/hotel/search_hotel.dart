// lib/pages/booking/hotel/search_hotel.dart

import 'package:flutter/material.dart';
// Pastikan import ini mengarah ke file manager kamu yang benar
import '../../../manager/hotel_manager.dart'; 

class SearchHotelPage extends StatefulWidget {
  const SearchHotelPage({super.key});

  @override
  State<SearchHotelPage> createState() => _SearchHotelPageState();
}

class _SearchHotelPageState extends State<SearchHotelPage> {
  // Gabungkan semua data hotel
  List<Hotel> _allHotels = [];
  List<Hotel> _foundHotels = [];

  @override
  void initState() {
    super.initState();
    // Mengambil data dari manager
    _allHotels = getAllHotels(); 
    _foundHotels = _allHotels;
  }

  // Fungsi filter pencarian
  void _runFilter(String enteredKeyword) {
    List<Hotel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allHotels;
    } else {
      results = _allHotels
          .where((hotel) =>
              hotel.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              hotel.city.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundHotels = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.orange, // Sesuai tema
        title: const Text(
          "Cari Hotel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ================= SEARCH BAR =================
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Cari hotel atau kota...',
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // ================= HOTEL LIST =================
            Expanded(
              child: _foundHotels.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada hotel ditemukan',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _foundHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = _foundHotels[index];
                        return _buildHotelCard(hotel);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Hotel
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              hotel.imageUrls.isNotEmpty
                  ? hotel.imageUrls[0]
                  : 'https://via.placeholder.com/400x200', // Placeholder jika url kosong
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          hotel.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      hotel.city,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  hotel.price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan navigasi ke detail jika sudah ada
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Memilih ${hotel.name}")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Lihat Detail"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}