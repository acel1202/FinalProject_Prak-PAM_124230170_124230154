// lib/service/api_serpapi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_serpapi_config.dart';
import '../manager/hive_hotel_manager.dart';

class HotelApiService {
  final String apiKey = SERPAPI_KEY;
  final String baseUrl = SERPAPI_HOTELS_BASE_URL;

  Future<List<HotelResultModel>> fetchHotels({
    required String destination,
    required String checkInDate,
    required String checkOutDate,
    String? hotelId,
  }) async {
    // Query tetap seperti logic kamu sebelumnya
    final String queryBase = destination.toLowerCase().contains("hotel")
        ? destination
        : "$destination resorts";

    final String encodedQuery = Uri.encodeQueryComponent(queryBase);

    final Map<String, String> params = {
      'engine': 'google_hotels',
      'q': encodedQuery,
      'check_in_date': checkInDate,
      'check_out_date': checkOutDate,
      'api_key': apiKey,
    };

    if (hotelId != null) {
      params['hotel_id'] = hotelId;
    }

    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // === FIX: Fallback semua kemungkinan struktur SerpAPI ===
        final List<dynamic> hotelResults =
            data['properties'] ??
            data['results'] ??
            data['hotels_results'] ??
            data['hotels'] ??
            [];

        if (hotelResults.isEmpty) {
          print(
            "⚠ API mengembalikan list kosong. Struktur JSON mungkin berbeda.",
          );
          return [];
        }

        return hotelResults.map((json) {
          // ========= Ambil Gambar =========
          String imageUrl = '';

          if (json['image'] != null && json['image'] is String) {
            imageUrl = json['image'];
          } else if (json['property_photo'] != null) {
            imageUrl = json['property_photo'];
          } else if (json['photos'] != null &&
              json['photos'] is List &&
              json['photos'].isNotEmpty &&
              json['photos'][0]['thumbnail'] != null) {
            imageUrl = json['photos'][0]['thumbnail'];
          } else if (json['photos'] != null &&
              json['photos'] is List &&
              json['photos'].isNotEmpty &&
              json['photos'][0]['image'] != null) {
            imageUrl = json['photos'][0]['image'];
          } else {
            imageUrl = ''; // fallback biar UI pakai ikon default
          }

          // ========= Ambil Nama, Rating, Alamat =========
          final name = json['name'] ?? 'Unknown Hotel';
          final rating = (json['overall_rating'] ?? json['rating'] ?? 0)
              .toDouble();
          final address = json['address'] ?? 'Alamat tidak tersedia';

          // ========= Harga (kosong saja, UI kamu tidak pakai) =========
          const String priceText = '';

          return HotelResultModel(
            hotelId: json['hotel_id']?.toString() ?? 'N/A',
            name: name,
            address: address,
            imageUrl: imageUrl,
            rating: rating,
            priceText: priceText,
          );
        }).toList();
      } else {
        print("❌ Gagal load hotel. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ API ERROR: $e");
      return [];
    }
  }
}
