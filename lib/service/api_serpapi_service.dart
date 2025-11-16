// lib/service/api_serpapi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; 
import '../config/api_serpapi_config.dart'; // SERPAPI_KEY & BASE_URL
import '../manager/hive_hotel_manager.dart'; // HotelResultModel

class HotelApiService {
  final String apiKey = SERPAPI_KEY; 
  final String baseUrl = SERPAPI_HOTELS_BASE_URL; 

  Future<List<HotelResultModel>> fetchHotels({
    required String destination,
    required String checkInDate, // Parameter ini tidak digunakan di URL lama, tapi dipertahankan
    required String checkOutDate, // Parameter ini tidak digunakan di URL lama, tapi dipertahankan
    String? hotelId,
  }) async {
    
    // Logika URL disalin dari proyek lama (Menggunakan q=query+resorts)
    final String query = destination + " resorts";
    final String encodedQuery = Uri.encodeComponent(query);
    
    // Kontruksi URL seperti yang ADA DI PROYEK LAMA ANDA, yang bekerja:
    // '$SERPAPI_HOTELS_BASE_URL&q=$query&gl=id&hl=id&api_key=$SERPAPI_KEY'
    final url = Uri.parse(
        '$SERPAPI_HOTELS_BASE_URL' 
        '&q=$encodedQuery' 
        '&gl=id&hl=id'
        '&api_key=$SERPAPI_KEY'
    );
    
    debugPrint('--- MENGGUNAKAN LOGIC PROYEK LAMA: $url ---');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // ✨ KUNCI KRITIS: Cek 'properties' dan 'search_results' (seperti di kode lama)
        final List properties = data['properties'] 
            ?? data['search_results']
            ?? data['hotels']
            ?? [];
        
        if (properties.isEmpty) {
            debugPrint('API SUKSES (200), TETAPI LIST HASIL KOSONG. Cek kuota API Key atau query.');
            return [];
        }

        debugPrint('SUKSES! Ditemukan ${properties.length} hasil.');
        
        // Map ke Model yang baru/disalin
        return properties
            .map((hotelJson) => HotelResultModel.fromJson(hotelJson))
            .toList();
        
      } else {
        debugPrint('Gagal memuat hotel. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Terjadi kesalahan jaringan/koneksi: ${e.toString()}');
      return [];
    }
  }
}