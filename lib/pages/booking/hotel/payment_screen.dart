// lib/pages/booking/hotel/payment_screen.dart

import 'package:flutter/material.dart';
import '../../utils/notification_service.dart';

class PaymentScreen extends StatefulWidget {
  final String hotelName;
  final double totalPrice;
  final String currency;
  final Future<void> Function() onPaymentSuccess;

  const PaymentScreen({
    super.key,
    required this.hotelName,
    required this.totalPrice,
    required this.currency,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool loading = false;

  void _pay() async {
    setState(() => loading = true);

    // Simulasi proses pembayaran (2s)
    await Future.delayed(const Duration(seconds: 2));

    // 1. panggil callback (misalnya simpan riwayat + pindah ke success page)
    await widget.onPaymentSuccess();

    // 2. tampilkan notifikasi lokal
    await NotificationService.showBookingSuccess(
      hotelName: widget.hotelName,
      totalPrice: widget.totalPrice,
      currency: widget.currency,
    );

    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              Text("Hotel: ${widget.hotelName}"),
              const SizedBox(height: 8),
              Text(
                "Total: ${widget.currency} ${widget.totalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _pay,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Bayar Sekarang",
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
