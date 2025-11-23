// lib/service/api_tripadvisor_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_serpapi_config.dart';

class TripadvisorApiService {
  final String _apiKey = SERPAPI_KEY;
  final String _baseUrl = 'https://serpapi.com/search.json';

  Future<List<Map<String, dynamic>>> searchTripadvisor({
    required String query,
    String ssrc = 'a',
    int limit = 20,
  }) async {
    if (query.isEmpty) {
      return [];
    }

    Map<String, String> params = {
      'engine': 'tripadvisor',
      'q': query,
      'ssrc': ssrc,
      'limit': limit.toString(),
      'api_key': _apiKey,
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> locations = data['locations'] ?? [];

        return locations.map((item) {
          return {
            'type': item['type'] ?? '—',
            'title': item['title'] ?? 'Unknown',
            'link': item['link'] ?? 'https://www.tripadvisor.com/', // Default link ke Tripadvisor.com
            'thumbnail': item['thumbnail'] ?? 'https://via.placeholder.com/150/FFB45F/FFFFFF?text=No+Image', // Placeholder dengan warna tema
            'rating': item['rating']?.toString() ?? '—',
            'reviews': item['number_of_reviews'] ?? 0,
            'description': item['snippet'] ?? item['description'] ?? 'No description available.',
            'category': item['category'] ?? '—',
          };
        }).toList();
      } else {
        throw Exception(
          '❌ Gagal memuat data dari Tripadvisor API: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('❌ Terjadi kesalahan saat memanggil API: $e');
    }
  }
}