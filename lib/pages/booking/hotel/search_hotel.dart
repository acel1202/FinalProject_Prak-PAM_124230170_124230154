// lib/pages/booking/hotel/search_hotel.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../manager/hive_hotel_manager.dart'; // Import Model
import '../../../service/api_serpapi_service.dart'; // Import Service

// Widget Khusus untuk Menampilkan Gambar Jaringan (Image.network)
class HotelImageWidget extends StatelessWidget {
  final HotelResultModel hotel;
  const HotelImageWidget({super.key, required this.hotel});

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

  @override
  Widget build(BuildContext context) {
    final bool showNetworkImage =
        hotel.imageUrl.isNotEmpty &&
        hotel.imageUrl != 'https://via.placeholder.com/300x200';

    if (showNetworkImage) {
      return Image.network(
        hotel.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Gagal memuat gambar: $error');
          return _buildImageFallback();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return _buildImageFallback();
    }
  }
}

// Halaman Detail Hotel
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Hotel
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: HotelImageWidget(hotel: hotel),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                hotel.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  // Rating
                  Text(
                    '${hotel.rating.toStringAsFixed(1)} Rating',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                hotel.address,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const Divider(height: 32),
              Text(
                'Deskripsi:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Deskripsi: Menggunakan alamat sebagai deskripsi jika Model lama tidak memiliki field deskripsi yang jelas
              Text(hotel.address, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              Text(
                'Harga per Malam: ${hotel.priceText}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Memproses Booking untuk ${hotel.name}'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Booking Sekarang',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Utama Pencarian Hotel (BookingHotelPage)
class BookingHotelPage extends StatefulWidget {
  const BookingHotelPage({super.key});

  @override
  State<BookingHotelPage> createState() => _BookingHotelPageState();
}

class _BookingHotelPageState extends State<BookingHotelPage> {
  final HotelApiService _apiService = HotelApiService();
  final TextEditingController _destinationController = TextEditingController();

  final DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  final DateTime _checkOutDate = DateTime.now().add(const Duration(days: 2));

  List<HotelResultModel> _hotels = [];
  bool _isLoading = false;
  String _message = 'Silakan masukkan destinasi untuk mencari hotel.';

  @override
  void initState() {
    super.initState();
    _loadInitialHotels();
  }

  void _loadInitialHotels() async {
    const initialDestination = 'Bali';

    setState(() {
      _isLoading = true;
      _message = 'Memuat hotel-hotel populer...';
      _destinationController.text = initialDestination;
    });

    await _fetchAndSetHotels(initialDestination);
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

    await _fetchAndSetHotels(destination);
  }

  Future<void> _fetchAndSetHotels(String destination) async {
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
                  onSubmitted: (_) => _searchHotels(),
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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
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
                // Gambar Hotel
                HotelImageWidget(hotel: hotel),

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
                          // Rating
                          Text(
                            '${hotel.rating.toStringAsFixed(1)} Rating',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          // Harga
                          Text(
                            hotel.priceText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Deskripsi/Alamat
                      Text(
                        // Menggunakan address karena description sering null/kosong di model lama.
                        hotel.address,
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
}
