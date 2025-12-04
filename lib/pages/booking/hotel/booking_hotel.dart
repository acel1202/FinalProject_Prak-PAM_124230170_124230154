import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../manager/hotel_manager.dart';
import '../../utils/currency_utils.dart';
import '../../utils/time_utils.dart';
import 'payment_screen.dart';
import 'success_booking_page.dart';

class BookingHotelPage extends StatefulWidget {
  final Hotel hotel;

  const BookingHotelPage({super.key, required this.hotel});

  @override
  State<BookingHotelPage> createState() => _BookingHotelPageState();
}

class _BookingHotelPageState extends State<BookingHotelPage> {
  int nights = 1;
  String currency = "IDR";

  // Date selection
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now().add(const Duration(days: 1));

  // Jam operasional
  String selectedTime = "WIB → 08:00";

  final List<String> opTimes = [
    "WIB → 08:00",
    "WITA → 09:00",
    "WIT → 10:00",
    "London → 01:00",
  ];

  double _extractPriceIDR(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  double get convertedPrice {
    final idrPrice = _extractPriceIDR(widget.hotel.price);
    return CurrencyUtils.convert(idrPrice * nights, "IDR", currency);
  }

  Future<void> _pickDate(bool isCheckIn) async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkIn : checkOut,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: isCheckIn
          ? "Pilih Tanggal Check-In"
          : "Pilih Tanggal Check-Out",
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
          checkOut = picked.add(Duration(days: nights));
        } else {
          checkOut = picked;
          nights = checkOut.difference(checkIn).inDays;
          if (nights <= 0) nights = 1;
        }
      });
    }
  }

  Future<void> _saveHotelHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList("hotel_history") ?? [];

    final now = DateTime.now();
    final formattedDate = TimeUtils.formatDate(now);

    final item = {
      "id": now.millisecondsSinceEpoch.toString(),
      "name": widget.hotel.name,
      "city": widget.hotel.city,
      "nights": nights,
      "currency": currency,
      "total_price": convertedPrice,
      "total_price_str": CurrencyUtils.formatCurrency(convertedPrice, currency),
      "date_raw": now.toIso8601String(),
      "date": formattedDate,
      "image": widget.hotel.imageUrls.isNotEmpty
          ? widget.hotel.imageUrls[0]
          : "",
      "status": "booked",
    };

    raw.add(jsonEncode(item));
    await prefs.setStringList("hotel_history", raw);
  }

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          hotelName: widget.hotel.name,
          totalPrice: convertedPrice,
          currency: currency,
          onPaymentSuccess: () async {
            await _saveHotelHistory();
            if (!mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SuccessBookingPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              hotel.imageUrls.isNotEmpty ? hotel.imageUrls[0] : "",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            hotel.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            hotel.city,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hotel.address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(hotel.description, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 16),

          // CHECK IN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Check-In", style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () => _pickDate(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(TimeUtils.formatDate(checkIn)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // CHECK OUT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Check-Out", style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () => _pickDate(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(TimeUtils.formatDate(checkOut)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "Jam Operasional:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: selectedTime,
              isExpanded: true,
              underline: const SizedBox(),
              items: opTimes.map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (v) {
                setState(() => selectedTime = v!);
              },
            ),
          ),

          const SizedBox(height: 16),

          const Text("Mata Uang", style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton<String>(
                value: currency,
                items: ["IDR", "USD", "EUR", "JPY", "CNY", "KRW"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => currency = v!),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Total: ${CurrencyUtils.formatCurrency(convertedPrice, currency)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _goToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Bayar Sekarang", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
