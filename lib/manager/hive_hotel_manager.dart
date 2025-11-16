// lib/manager/hive_hotel_manager.dart

import 'dart:math';

// Placeholder manager (Menghilangkan dependensi database)
class HiveHotelManager {
  // Dibiarkan kosong
}

// Model Hotel yang disalin dari HOTEL_MODEL.DART lama Anda
class HotelResultModel {
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final String priceText;
  final String hotelId; // Tambahan field untuk menyesuaikan constructor baru
  // Field description DIHILANGKAN agar tidak menyebabkan error parsing.

  HotelResultModel({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.priceText,
    required this.hotelId, 
  });

  factory HotelResultModel.fromJson(Map<String, dynamic> json) {
    final random = Random();
    
    // 1. Parsing Nama & ID
    final name = (json['name'] ?? json['title'] ?? 'Unknown').toString();
    final hotelId = json['hotel_id']?.toString() ?? 'N/A';

    // 2. Parsing Alamat
    final address =
        (json['address'] ??
                json['vicinity'] ??
                json['location'] ??
                json['formatted_address'] ??
                'Alamat tidak tersedia')
            .toString();

    // 3. Parsing Rating
    final ratingRaw = json['overall_rating'] ?? json['rating'] ?? 0;
    final rating = ratingRaw is num ? ratingRaw.toDouble() : 0.0;

    // 4. Parsing Gambar (Logika persis dari proyek lama)
    final imageUrl =
        (json['thumbnail'] ??
                (json['images'] is List && json['images'].isNotEmpty
                    ? json['images'][0]['thumbnail'] ??
                          json['images'][0]['image']
                    : null) ??
                'https://via.placeholder.com/300x200') // Placeholder yang sama
            .toString();

    // 5. Logika Harga (Menggunakan logika dummy harga dari proyek lama)
    double priceUsd = 0.0;
    String priceText = 'Cek Harga';
    
    // (Logika parsing harga dari proyek lama Anda, disalin sepenuhnya)
    if (json['rate_per_night'] is Map) {
      final rate = json['rate_per_night']['lowest'] ?? json['rate_per_night']['average'];
      if (rate is Map && rate['extracted_value'] != null) {
        priceUsd = (rate['extracted_value'] as num).toDouble();
        priceText = rate['price'] ?? 'USD ${priceUsd.toStringAsFixed(2)}';
      }
    } else if (json['prices'] is List && (json['prices'] as List).isNotEmpty) {
      final first = json['prices'].first as Map;
      final rateStr = (first['rate'] ?? '').toString();
      if (rateStr.isNotEmpty) {
        final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)').firstMatch(rateStr);
        if (match != null) priceUsd = double.parse(match.group(1)!);
        priceText = rateStr;
      }
    }
    
    // Logika Dummy Harga
    if (priceUsd == 0.0) {
      double minPrice, maxPrice;
      if (rating >= 4.8) {
        minPrice = 300; maxPrice = 600;
      } else if (rating >= 4.5) {
        minPrice = 150; maxPrice = 300;
      } else if (rating >= 4.0) {
        minPrice = 80; maxPrice = 150;
      } else {
        minPrice = 50; maxPrice = 80;
      }
      priceUsd = minPrice + random.nextDouble() * (maxPrice - minPrice);
      priceText = "USD ${priceUsd.toStringAsFixed(2)}";
    }

    return HotelResultModel(
      hotelId: hotelId,
      name: name,
      address: address,
      imageUrl: imageUrl,
      rating: rating,
      priceText: priceText,
    );
  }
}