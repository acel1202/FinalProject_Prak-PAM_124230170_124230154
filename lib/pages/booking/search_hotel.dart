// lib/pages/booking/search_hotel.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../manager/hive_hotel_manager.dart'; 
import '../../service/api_serpapi_service.dart'; 

// Placeholder untuk Halaman Detail Hotel (Tidak perlu diubah)
class HotelDetailPage extends StatelessWidget {
  final HotelResultModel hotel;
  final String checkInDate;
  final String checkOutDate;

  const HotelDetailPage({
    super.key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: Center(child: Text('Detail untuk ${hotel.name}')),
    );
  }
}

class BookingHotelPage extends StatefulWidget {
  const BookingHotelPage({super.key});

  @override
  State<BookingHotelPage> createState() => _BookingHotelPageState();
}

class _BookingHotelPageState extends State<BookingHotelPage> {
  final HotelApiService _apiService = HotelApiService();
  final TextEditingController _destinationController = TextEditingController();

  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 2));

  List<HotelResultModel> _hotels = [];
  bool _isLoading = false;
  String _message = 'Silakan masukkan destinasi untuk mencari hotel.';

  @override
  void initState() {
    super.initState();
    _loadInitialHotels();
  }

  void _loadInitialHotels() async {
    // Menggunakan Bali untuk Discovery karena hasil gambarnya terbukti lebih baik
    const initialDestination = 'Bali'; 
    
    setState(() {
      _isLoading = true;
      _message = 'Memuat hotel-hotel populer...';
      _destinationController.text = initialDestination;
    });

    final checkInStr = DateFormat('yyyy-MM-dd').format(_checkInDate);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(_checkOutDate);

    final results = await _apiService.fetchHotels(
      destination: initialDestination,
      checkInDate: checkInStr,
      checkOutDate: checkOutStr,
    );

    setState(() {
      _hotels = results;
      _isLoading = false;
      if (_hotels.isEmpty) {
        _message =
            'Gagal memuat hotel. Coba cari manual atau periksa koneksi/API Key.';
      } else {
        _message = 'Hasil Discovery Hotel';
      }
    });
  }

  void _searchHotels() async {
    final destination = _destinationController.text;
    if (destination.isEmpty) {
      setState(() => _message = 'Mohon masukkan destinasi tujuan.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = 'Mencari hotel untuk "$destination"...';
      _hotels = [];
    });

    final checkInStr = DateFormat('yyyy-MM-dd').format(_checkInDate);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(_checkOutDate);

    final results = await _apiService.fetchHotels(
      destination: destination,
      checkInDate: checkInStr,
      checkOutDate: checkOutStr,
    );

    setState(() {
      _hotels = results;
      _isLoading = false;
      if (_hotels.isEmpty) {
        _message =
            'Tidak ada hotel ditemukan untuk "$destination". Coba destinasi lain.';
      } else {
        _message = 'Hasil pencarian untuk "$destination"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari & Booking Hotel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔹 Input Form Pencarian (Hanya Destinasi)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destinasi (Contoh: Bali, Jakarta)',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _searchHotels,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Cari Hotel',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Hasil Discovery
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    _message,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_hotels.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _message,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = _hotels[index];
                        return _buildDiscoveryCard(context, hotel);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk tampilan card besar ala Discovery
  Widget _buildDiscoveryCard(BuildContext context, HotelResultModel hotel) {
    final bool showNetworkImage = hotel.imageUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailPage(
                hotel: hotel,
                checkInDate: DateFormat('yyyy-MM-dd').format(_checkInDate),
                checkOutDate: DateFormat('yyyy-MM-dd').format(_checkOutDate),
              ),
            ),
          );
        },
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar Hotel atau Ikon Default
                showNetworkImage
                    ? Image.network(
                        hotel.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _buildImageFallback(),
                      )
                    : _buildImageFallback(), 

                // Gradien Overlay untuk teks
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),

                // Detail Hotel
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${hotel.rating.toStringAsFixed(1)} Rating',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        hotel.description ?? hotel.address,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget fallback gambar internal Flutter
  Widget _buildImageFallback() {
    return Container(
      color: Colors.grey.shade400,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel_outlined, color: Colors.white, size: 60),
            SizedBox(height: 8),
            Text(
              "Gambar Tidak Tersedia",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}