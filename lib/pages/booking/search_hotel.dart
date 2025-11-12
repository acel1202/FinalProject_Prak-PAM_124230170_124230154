import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hotel_result_model.dart';
import '../service/api_serpapi_service.dart';
import 'booking/hotel_detail_page.dart'; // Pastikan path benar

class BookingHotelPage extends StatefulWidget {
  const BookingHotelPage({super.key});

  @override
  State<BookingHotelPage> createState() => _BookingHotelPageState();
}

class _BookingHotelPageState extends State<BookingHotelPage> {
  final ApiSerpApiHotelService _apiService = ApiSerpApiHotelService();
  final TextEditingController _destinationController = TextEditingController();
  
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 2));
  
  List<HotelResultModel> _hotels = [];
  bool _isLoading = false;
  String _message = 'Silakan masukkan destinasi dan tanggal untuk mencari hotel.';

  // Fungsi untuk memilih tanggal check-in
  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate.isBefore(picked)) {
          _checkOutDate = picked.add(const Duration(days: 1));
        }
      });
    }
  }

  // Fungsi untuk memilih tanggal check-out
  Future<void> _selectCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate.isAfter(_checkInDate) ? _checkOutDate : _checkInDate.add(const Duration(days: 1)),
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  // Fungsi pencarian hotel
  void _searchHotels() async {
    if (_destinationController.text.isEmpty) {
      setState(() => _message = 'Mohon masukkan destinasi tujuan.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = 'Mencari hotel...';
    });
    
    final checkInStr = DateFormat('yyyy-MM-dd').format(_checkInDate);
    final checkOutStr = DateFormat('yyyy-MM-dd').format(_checkOutDate);

    final results = await _apiService.fetchHotels(
      destination: _destinationController.text,
      checkInDate: checkInStr,
      checkOutDate: checkOutStr,
    );

    setState(() {
      _hotels = results;
      _isLoading = false;
      if (_hotels.isEmpty) {
        _message = 'Tidak ada hotel ditemukan. Coba destinasi lain.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari & Booking Hotel', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔹 Input Form Pencarian
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildDateButton('Check-in', _checkInDate, _selectCheckInDate)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildDateButton('Check-out', _checkOutDate, _selectCheckOutDate)),
                  ],
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text('Cari Hotel', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          
          // 🔹 Hasil Pencarian
          Expanded(
            child: _hotels.isEmpty && !_isLoading
                ? Center(child: Text(_message, style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _hotels[index];
                      return _buildHotelCard(context, hotel);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime date, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Text(DateFormat('dd MMM yyyy').format(date)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, HotelResultModel hotel) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            hotel.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 80, height: 80, color: Colors.grey.shade200, child: const Icon(Icons.hotel_outlined, color: Colors.grey)),
          ),
        ),
        title: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hotel.address, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(hotel.rating.toStringAsFixed(1)),
              ],
            ),
            Text(
              hotel.priceText,
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
      ),
    );
  }
}