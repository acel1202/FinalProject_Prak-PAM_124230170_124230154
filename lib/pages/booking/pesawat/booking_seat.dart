import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../payment/payment_screen.dart';

class BookingSeatPage extends StatefulWidget {
  final Map<String, dynamic> flight;

  const BookingSeatPage({super.key, required this.flight});

  @override
  State<BookingSeatPage> createState() => _BookingSeatPageState();
}

class _BookingSeatPageState extends State<BookingSeatPage> {
  String? selectedSeat;

  late String airline;
  late String cabin;
  late double basePrice;

  List<String> seatLetters = [];
  int rowCount = 0;

  @override
  void initState() {
    super.initState();

    airline = widget.flight['airline'] ?? 'Airline';
    cabin = widget.flight['cabin'] ?? 'ECONOMY';
    basePrice = double.tryParse(widget.flight['price'].toString()) ?? 0;

    _generateSeatLayout();
  }

  void _generateSeatLayout() {
    switch (cabin.toUpperCase()) {
      case "FIRST":
        seatLetters = ['A', 'B'];
        rowCount = 8;
        break;
      case "BUSINESS":
        seatLetters = ['A', 'C', 'D', 'F'];
        rowCount = 12;
        break;
      case "PREMIUM":
      case "PREMIUM ECONOMY":
        seatLetters = ['A', 'B', 'C', 'D'];
        rowCount = 20;
        break;
      default:
        seatLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
        rowCount = 28;
    }
  }

  double _seatPrice(String seat) {
    if (seat.endsWith("A") || seat.endsWith("F")) return basePrice + 90000;
    if (seat.endsWith("C") || seat.endsWith("D")) return basePrice + 60000;
    return basePrice + 30000;
  }

  Widget _seatBox(String seat) {
    final bool isSelected = selectedSeat == seat;

    return GestureDetector(
      onTap: () => setState(() => selectedSeat = seat),
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Text(
          seat,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _seatGrid() {
    return Column(
      children: [
        for (int row = 1; row <= rowCount; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (String letter in seatLetters)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _seatBox("$row$letter"),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final from = widget.flight['from'] ?? '-';
    final to = widget.flight['to'] ?? '-';
    final departure = widget.flight['departure'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Choose Your Seat"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          /// FLIGHT CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  airline,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text("$from → $to"),
                Text("Departure: $departure"),
                Text("Cabin: $cabin"),
              ],
            ),
          ),

          const Text(
            "Seat Map",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          Expanded(child: SingleChildScrollView(child: _seatGrid())),

          /// BOTTOM BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedSeat == null
                  ? null
                  : () {
                      final totalPrice = _seatPrice(selectedSeat!);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            bookingId: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            baseAmount: totalPrice,
                            flightFrom: from,
                            flightTo: to,
                            departure: departure,
                            airline: airline,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                selectedSeat == null
                    ? "Select a Seat"
                    : "Continue — Pay ${NumberFormat('#,###', 'id_ID').format(_seatPrice(selectedSeat!)).replaceAll(',', '.')}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
