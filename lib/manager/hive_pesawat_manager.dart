// lib/manager/hive_pesawat_manager.dart

// Sama seperti hive_hotel_manager.dart:
// Tidak memakai Hive langsung kecuali ingin mengaktifkan bagian model Hive.
// import 'package:hive/hive.dart';
// part 'hive_pesawat_manager.g.dart';

/// ======================================================================
///  MODEL UNTUK HASIL PENCARIAN PESAWAT (UNTUK DITAMPILKAN DI UI)
/// ======================================================================

class FlightResultModel {
  final String airline;
  final String flightNo;
  final String departureTime;
  final String duration;
  final String from;
  final String to;
  final String priceText; // harga sebagai string ex: "Rp 1.200.000"
  final String date; // tanggal keberangkatan (yyyy-mm-dd)
  final String? logoUrl; // Opsional untuk logo maskapai
  final String cabinClass;

  FlightResultModel({
    required this.airline,
    required this.flightNo,
    required this.departureTime,
    required this.duration,
    required this.from,
    required this.to,
    required this.priceText,
    required this.date,
    this.logoUrl,
    this.cabinClass = "ECONOMY",
  });
}

/// ======================================================================
///  MODEL UNTUK BOOKING PESAWAT (jika ingin disimpan di Hive nanti)
///  Non-aktif, aktifkan kalau mau generate adapter Hive.
/// ======================================================================

/*
@HiveType(typeId: 1)
class FlightBookingModel extends HiveObject {
  @HiveField(0)
  final String bookingId;

  @HiveField(1)
  final String airline;

  @HiveField(2)
  final String from;

  @HiveField(3)
  final String to;

  @HiveField(4)
  final String departure;

  @HiveField(5)
  final String arrival;

  @HiveField(6)
  final String seatClass;

  @HiveField(7)
  final String seatMap; // JSON String list kursi

  @HiveField(8)
  final int passengers;

  @HiveField(9)
  final double totalPrice;

  @HiveField(10)
  final String status;

  @HiveField(11)
  final String passengerName;

  @HiveField(12)
  final String passengerEmail;

  @HiveField(13)
  final String passengerPhone;

  FlightBookingModel({
    required this.bookingId,
    required this.airline,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.seatClass,
    required this.seatMap,
    required this.passengers,
    required this.totalPrice,
    required this.status,
    required this.passengerName,
    required this.passengerEmail,
    required this.passengerPhone,
  });
}
*/
