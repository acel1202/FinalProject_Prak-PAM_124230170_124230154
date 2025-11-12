import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalproject_124230170_124230154/config/api_serpapi_config.dart'; // Ganti path jika perlu

class HotelApiService {
  final String apiKey = ApiSerpApiConfig.apiKey;
  final String baseUrl = ApiSerpApiConfig.baseUrl;

  // Fungsi untuk mengambil daftar hotel (simulasi)
  Future<List<Map<String, dynamic>>> fetchHotels({
    required String destination,
    required String checkInDate,
    required String checkOutDate,
  }) async {
    // Parameter yang diperlukan SerpApi untuk Google Hotels
    final Map<String, String> params = {
      'engine': 'google_hotels',
      'q': destination, // Kota atau nama hotel
      'check_in_date': checkInDate, // Format YYYY-MM-DD
      'check_out_date': checkOutDate, // Format YYYY-MM-DD
      'api_key': apiKey,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Ambil data dari 'properties' atau 'hotels' (tergantung respons API)
        // Karena respons SerpApi bisa bervariasi, kita hanya ambil data "featured" untuk simulasi
        final List<dynamic> hotelResults = data['properties'] ?? data['hotels_results'] ?? [];
        
        // Memformat data menjadi format yang lebih sederhana untuk ditampilkan
        return hotelResults.map((json) {
          return {
            'hotel_id': json['hotel_id']?.toString() ?? 'N/A',
            'name': json['name'] ?? 'Nama Hotel Tidak Diketahui',
            'rating': json['overall_rating'] ?? 0.0,
            'price': json['price']?['total_price'] ?? 'N/A', // Ambil harga
            'image_url': json['image'] ?? 'https://via.placeholder.com/150',
            'address': json['address'] ?? 'Alamat Tidak Tersedia',
          };
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