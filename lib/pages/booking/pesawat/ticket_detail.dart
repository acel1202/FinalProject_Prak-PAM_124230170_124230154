// lib/pages/booking/pesawat/ticket_detail.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../payment/payment_screen.dart';

class TicketDetailPage extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> flight;
  const TicketDetailPage({
    super.key,
    required this.bookingId,
    required this.flight,
  });

  String _formatIDR(num value) {
    final f = NumberFormat('#,###', 'id_ID');
    return 'Rp ${f.format(value).replaceAll(',', '.')}';
  }

  String _formatTime(String iso) {
    if (iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('EEE, dd MMM yyyy • HH:mm').format(dt);
    } catch (_) {
      if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(iso)) return iso;
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final airline = flight['airline'] ?? 'Unknown';
    final from = flight['from'] ?? '-';
    final to = flight['to'] ?? '-';
    final departure = flight['departure'] ?? '';
    final arrival = flight['arrival'] ?? '';
    final flightNo = flight['flightNo'] ?? '-';
    final duration = flight['duration'] ?? '-';
    final aircraft = flight['aircraft'] ?? '-';
    final price = (flight['price'] is num)
        ? flight['price'] as num
        : double.tryParse(flight['price']?.toString() ?? '0') ?? 0;
    final priceText = _formatIDR(price);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1220),
        elevation: 0,
        title: const Text('My Ticket', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2B45),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        child: const Icon(Icons.flight, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          airline,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        priceText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$from → $to',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Text(
                        'Duration: $duration',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flight',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              from,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatTime(departure),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              to,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatTime(arrival),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flight No',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                flightNo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aircraft',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                aircraft,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Class',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                flight['cabin'] ?? 'Economy',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < 30; i++)
                              Container(
                                width: i % 3 == 0 ? 8 : 3,
                                height: 48,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                color: i % 2 == 0
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                bookingId: bookingId,
                                baseAmount: price.toDouble(),
                                flightFrom: from,
                                flightTo: to,
                                departure: departure,
                                airline: airline,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B2B45),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
