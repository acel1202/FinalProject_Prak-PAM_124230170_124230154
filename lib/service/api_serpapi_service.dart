// lib/service/api_serpapi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Untuk debugPrint/print
import '../config/api_serpapi_config.dart';
import '../manager/hive_hotel_manager.dart'; // Mengambil HotelResultModel dari sini

class HotelApiService {
  final String apiKey = SERPAPI_KEY;
  final String baseUrl = SERPAPI_HOTELS_BASE_URL;

  Future<List<HotelResultModel>> fetchHotels({
    required String destination,
    required String checkInDate,
    required String checkOutDate,
    String? hotelId,
  }) async {
    // Logic Query Modification Anda (Menambahkan 'resorts')
    final String queryBase = destination.toLowerCase().contains("hotel")
        ? destination
        : "$destination resorts";

    final String encodedQuery = Uri.encodeQueryComponent(queryBase);

    final Map<String, String> params = {
      'engine': 'google_hotels',
      'q': encodedQuery,
      'check_in_date': checkInDate,
      'check_out_date': checkOutDate,
      'apikey': apiKey, // Menggunakan 'apikey' sesuai SerpAPI
      'gl': 'id', 
      'hl': 'id',
    };

    if (hotelId != null) {
      params['hotel_id'] = hotelId;
    }

    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ✨ PERBAIKAN: Cari hasil hotel di lokasi yang tepat dalam respons JSON SerpAPI
        final List<dynamic> hotelResults = data['hotels'] 
            ?? data['suggested_hotels'] 
            ?? data['properties']?['shopping_results']
            ?? [];

        if (hotelResults.isEmpty) {
          debugPrint('API SUCCESS: Tidak ada hasil hotel ditemukan dalam respons.');
          return [];
        }

        // Mapping menggunakan factory constructor yang sudah diperbaiki
        return hotelResults
            .map<HotelResultModel>((json) => HotelResultModel.fromJson(json))
            .toList();

      } else {
        debugPrint('Gagal memuat hotel. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Terjadi kesalahan koneksi API: $e');
      return [];
    }
  }
}