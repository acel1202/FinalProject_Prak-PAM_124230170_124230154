// lib/manager/hive_hotel_manager.dart

// Hapus atau abaikan baris yang berhubungan dengan Hive/build_runner jika tidak dipakai
// import 'package:hive/hive.dart';
// part 'hive_hotel_manager.g.dart'; 
// Asumsi: Kita hanya mendefinisikan model data di sini.

// Model yang digunakan untuk menampung hasil data dari SerpApi
class HotelResultModel {
  final String hotelId;
  final String name;
  final double rating;
  final String priceText; // Harga dalam bentuk String
  final String imageUrl;
  final String address;
  final String? description; // Tambahkan deskripsi untuk tampilan awal

  HotelResultModel({
    required this.hotelId,
    required this.name,
    required this.rating,
    required this.priceText,
    required this.imageUrl,
    required this.address,
    this.description,
  });
}

// Model Hive (Jika Anda benar-benar menggunakan Hive untuk Riwayat)
/*
@HiveType(typeId: 0)
class BookingModel extends HiveObject {
  @HiveField(0)
  final String bookingId; 
  
  @HiveField(1)
  final String hotelName;
  
  @HiveField(2)
  final String checkInDate;
  
  @HiveField(3)
  final String checkOutDate;
  
  @HiveField(4)
  final int numberOfGuests;
  
  @HiveField(5)
  final double totalPrice;
  
  @HiveField(6)
  final String imageUrl; 

  BookingModel({
    required this.bookingId,
    required this.hotelName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.imageUrl,
  });
}
*/