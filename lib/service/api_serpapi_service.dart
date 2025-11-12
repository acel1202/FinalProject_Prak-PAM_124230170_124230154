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
    // START FIX: Menggabungkan logic Query Modification dari proyek lama.
    // Menambahkan 'resorts' ke query untuk hasil yang lebih kaya gambar,
    // seperti pada implementasi lama Anda yang berhasil.
    final String queryBase = destination.toLowerCase().contains("hotel")
        ? destination
        : "$destination resorts";

    // Encoding Query String
    final String encodedQuery = Uri.encodeQueryComponent(queryBase);
    // END FIX

    final Map<String, String> params = {
      'engine': 'google_hotels',
      'q': encodedQuery, // Menggunakan query yang dimodifikasi dan di-encode
      'check_in_date': checkInDate,
      'check_out_date': checkOutDate,
      'api_key': apiKey,
    };

    if (hotelId != null) {
      params['hotel_id'] = hotelId;
    }

    // Mengganti penggunaan Uri.parse.replace dengan pembangunan URL yang lebih lugas
    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Cek 'properties' atau 'hotels_results' untuk hasil hotel.
        final List<dynamic> hotelResults =
            data['properties'] ?? data['hotels_results'] ?? [];

        return hotelResults.map((json) {
          final name = json['name'] ?? 'Nama Hotel Tidak Diketahui';
          final rating = json['overall_rating'] ?? 0.0;

          // HARGA DIHILANGKAN (string kosong)
          const String priceText = '';

          final address = json['address'] ?? 'Alamat tidak tersedia';
          final description = json['description'];

          // Gambar: Diatur kosong jika API tidak menyediakannya
          final String imageUrl =
              (json['image'] is String && (json['image'] as String).isNotEmpty)
              ? json['image'] as String
              : '';

          return HotelResultModel(
            hotelId: json['hotel_id']?.toString() ?? 'N/A',
            name: name,
            rating: rating.toDouble(),
            priceText: priceText,
            imageUrl: imageUrl,
            address: address,
            description: description,
          );
        }).toList();
      } else {
        print('Gagal memuat hotel. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Terjadi kesalahan koneksi API: $e');
      return [];
    }
  }
}
