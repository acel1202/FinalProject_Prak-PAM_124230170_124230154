// lib/manager/hive_hotel_manager.dart

// Placeholder manager agar import di file service tidak error
class HiveHotelManager {
  // Placeholder manager
}

// Model Data Hotel yang disesuaikan untuk respons SerpAPI
class HotelResultModel {
  final String hotelId;
  final String name;
  final double rating;
  final String priceText; 
  final String imageUrl; // <-- INI YANG KRUSIAL
  final String address;
  final String? description;

  HotelResultModel({
    required this.hotelId,
    required this.name,
    required this.rating,
    required this.priceText,
    required this.imageUrl,
    required this.address,
    this.description,
  });

  // Factory Constructor untuk mengurai JSON dari SerpAPI
  factory HotelResultModel.fromJson(Map<String, dynamic> json) {
    
    // ✨ PERBAIKAN: Cari kunci gambar yang paling mungkin, yaitu 'thumbnail' atau 'main_image'.
    final String image = json['thumbnail'] 
        ?? json['main_image'] 
        ?? json['image'] 
        ?? ''; // Default ke string kosong jika tidak ada gambar

    // Ambil rating dan pastikan diubah ke double
    final double overallRating = (json['overall_rating'] is num) 
        ? json['overall_rating'].toDouble() 
        : 0.0;
        
    // Ambil harga. Karena Anda mengaturnya kosong di kode lama, kita pertahankan priceText
    final String price = json['price']?.toString() 
        ?? json['rates']?[0]?['price']?.toString() 
        ?? '';
        
    final String priceText = price.isNotEmpty 
        ? 'Rp ${price}' 
        : 'Cek Harga';

    return HotelResultModel(
      hotelId: json['hotel_id']?.toString() ?? 'N/A',
      name: json['name'] ?? 'Nama Hotel Tidak Diketahui',
      rating: overallRating,
      priceText: priceText,
      imageUrl: image, // Menggunakan variabel 'image' yang sudah dicari
      address: json['address'] ?? 'Alamat tidak tersedia',
      description: json['description'],
    );
  }
}