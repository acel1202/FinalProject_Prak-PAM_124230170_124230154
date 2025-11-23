// lib/pages/dashboard/discovery_page.dart (KODE LENGKAP DIPERBARUI)

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka URL
import '../../../service/api_tripadvisor_service.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final TripadvisorApiService _apiService = TripadvisorApiService();
  List<Map<String, dynamic>> _exploreData = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = 'Korea'; // Query awal diset ke Korea untuk demo
  
  // Filter yang tersedia dari Tripadvisor API: 'a'=All, 'g'=Destinations, 'h'=Hotels, 'r'=Restaurants, 'A'=Things to Do
  String _selectedSsrc = 'h'; // Default ke Hotels (sesuai screenshot Anda)
  final Map<String, String> _ssrcOptions = {
    'g': 'Destinations',
    'h': 'Hotels',
    'A': 'Things to Do',
    'r': 'Restaurants',
    'a': 'All Results',
  };


  @override
  void initState() {
    super.initState();
    _searchController.text = _currentQuery;
    _fetchExploreData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted() {
    final newQuery = _searchController.text.trim();

    if (newQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search query')),
      );
      return;
    }

    if (newQuery == _currentQuery) return;

    setState(() {
      _currentQuery = newQuery;
    });
    _fetchExploreData();
  }

  Future<void> _fetchExploreData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await _apiService.searchTripadvisor(
        query: _currentQuery,
        ssrc: _selectedSsrc,
        limit: 10,
      );
      
      if (mounted) {
        setState(() {
          _exploreData = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching Tripadvisor data: $e');
      if (mounted) {
        setState(() {
          _exploreData = _useDummyData(); // Fallback ke dummy data
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load live data. Showing dummy data.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Fungsi Dummy Data disesuaikan agar sesuai dengan struktur Tripadvisor
  List<Map<String, dynamic>> _useDummyData() {
    return [
      {
        'type': 'DESTINATION',
        'title': 'Casablanca',
        'link': 'https://www.tripadvisor.com/Tourism-g293737-Casablanca_Casablanca_Settat-Vacations.html',
        'thumbnail': 'https://images.unsplash.com/photo-1627850849315-0d04b321a55f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1ODc1NjF8MHwxfHNlYXJjaHwxfHxDYXNhYmxhbmNhfGVufDB8fHx8MTcyODU0MzM3NnwMA&ixlib=rb-4.0.3&q=80&w=400',
        'rating': '4.0',
        'reviews': 1000,
        'description': 'It is the largest city in Morocco and is its economic capital and one of the largest and most important cities in Africa.',
        'category': 'Destination',
      },
      {
        'type': 'HOTEL',
        'title': 'ibis Styles Ambassador Seoul Myeongdong',
        'link': 'https://www.tripadvisor.com/Hotel_Review-g294197-d8664426-Reviews-Ibis_Styles_Ambassador_Seoul_Myeongdong-Seoul.html',
        'thumbnail': 'https://images.unsplash.com/photo-1625244724122-aa288410f9b3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1ODc1NjF8MHwxfHNlYXJjaHwxfHxzZW91bCUyMGhvdGVsfGVufDB8fHx8MTcyODU0MzM5Mnww&ixlib=rb-4.0.3&q=80&w=400',
        'rating': '4.2',
        'reviews': 850,
        'description': 'Modern hotel in the heart of Myeongdong, Seoul, offering stylish rooms and city views.',
        'category': 'Hotel',
      },
       {
        'type': 'THINGS_TO_DO',
        'title': 'N Seoul Tower',
        'link': 'https://www.tripadvisor.com/Attraction_Review-g294197-d306660-Reviews-N_Seoul_Tower-Seoul.html',
        'thumbnail': 'https://images.unsplash.com/photo-1510257321689-5374828b185f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1ODc1NjF8MHwxfHNlYXJjaHwxfHxzZW91bCUyMHRvd2VyfGVufDB8fHx8MTcyODU0MzQ1MXww&ixlib=rb-4.0.3&q=80&w=400',
        'rating': '4.6',
        'reviews': 1500,
        'description': 'A landmark observation tower in Seoul, South Korea, offering panoramic city views.',
        'category': 'Activity',
      },
    ];
  }

  // Fungsi untuk membuka URL
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna dari tema aplikasi
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Menggunakan warna background dari tema
      appBar: AppBar(
        title: const Text('Discover'), // Judul diubah menjadi "Discover"
        backgroundColor: colorScheme.primary, // Warna AppBar dari tema
        foregroundColor: colorScheme.onPrimary, // Warna teks di AppBar dari tema
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER & FILTER =================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Card lebih bulat
                elevation: 6, // Shadow sedikit lebih dalam
                color: colorScheme.surface, // Warna surface dari tema
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Query
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Search Query (e.g., Rome)',
                                prefixIcon: Icon(Icons.location_city, color: colorScheme.primary),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                              onSubmitted: (value) => _onSearchSubmitted(), 
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _onSearchSubmitted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Search', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Filter Results
                      DropdownButtonFormField<String>(
                        value: _selectedSsrc,
                        decoration: InputDecoration(
                          labelText: 'Filter Results',
                          prefixIcon: Icon(Icons.filter_list, color: colorScheme.secondary),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        items: _ssrcOptions.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedSsrc = v!;
                          });
                          _fetchExploreData();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // ================= RESULTS LIST =================
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                  : _exploreData.isEmpty
                      ? Center(
                          child: Text(
                            'No results found for "$_currentQuery"',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _exploreData.length,
                          itemBuilder: (context, index) {
                            return _buildDiscoveryCard(context, _exploreData[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk setiap kartu hasil pencarian
  Widget _buildDiscoveryCard(BuildContext context, Map<String, dynamic> data) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String title = data['title'] ?? 'Unknown';
    final String description = data['description'] ?? 'No description available.';
    final String thumbnail = data['thumbnail'] ?? 'https://via.placeholder.com/150/FFB45F/FFFFFF?text=No+Image';
    final String link = data['link'] ?? 'https://www.tripadvisor.com/'; // Pastikan ada fallback link
    final String category = data['category'] ?? 'Location'; // Kategori default

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias, // Penting untuk gambar melengkung
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8, // Sedikit lebih tebal untuk efek 3
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell( // Untuk efek ripple saat diklik
        onTap: () => _launchUrl(link), // Mengklik kartu akan membuka link
        child: Container(
          height: 350, // Tinggi kartu disesuaikan
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(thumbnail),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), // Overlay gelap untuk teks lebih jelas
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Gradien di bagian bawah untuk teks
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Konten utama kartu
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: colorScheme.onPrimary.withOpacity(0.8), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          category, // Menampilkan kategori di sini
                          style: TextStyle(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        if (data['rating'] != '—') ...[ // Tampilkan rating jika ada
                          const SizedBox(width: 8),
                          Icon(Icons.star, color: Colors.amber.shade300, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${data['rating']}',
                            style: TextStyle(
                              color: colorScheme.onPrimary.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Tombol "View" kecil
                    Align(
                      alignment: Alignment.bottomRight, // Memindahkan tombol ke kanan bawah
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary, // Warna tombol dari tema
                          borderRadius: BorderRadius.circular(10), // Lebih bulat
                        ),
                        child: Material(
                          color: Colors.transparent, // Agar efek inkwell transparan
                          child: InkWell(
                            onTap: () => _launchUrl(link),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Agar lebar menyesuaikan konten
                                children: [
                                  Icon(Icons.visibility, color: colorScheme.onPrimary, size: 18), // Icon View
                                  const SizedBox(width: 6),
                                  Text(
                                    'View', // Hanya "View"
                                    style: TextStyle(
                                      color: colorScheme.onPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}