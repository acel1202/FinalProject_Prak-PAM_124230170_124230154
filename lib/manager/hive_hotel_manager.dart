import 'package:hive/hive.dart';

part 'hive_hotel_manager.g.dart'; // File akan di-generate oleh build_runner

@HiveType(typeId: 0)
class BookingModel extends HiveObject {
  @HiveField(0)
  final String bookingId; // ID unik untuk booking
  
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
  final String imageUrl; // URL gambar hotel

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