// lib/pages/booking/flight/search_flight.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import seat selection
import '../../booking/pesawat/booking_pesawat.dart';

// Import API Service
import '../../../service/api_amadeus_service.dart';

// ========================================================
// ===============    FLIGHT SEARCH SCREEN    =============
// ========================================================

class SearchFlightPage extends StatefulWidget {
  final String? preselectedDestination;

  const SearchFlightPage({super.key, this.preselectedDestination});

  @override
  State<SearchFlightPage> createState() => _SearchFlightPageState();
}

class _SearchFlightPageState extends State<SearchFlightPage> {
  final List<Map<String, String>> airports = [
    {'code': 'CGK', 'city': 'Jakarta (Soekarno-Hatta)'},
    {'code': 'DPS', 'city': 'Bali (Ngurah Rai)'},
    {'code': 'SUB', 'city': 'Surabaya (Juanda)'},
    {'code': 'KNO', 'city': 'Medan (Kualanamu)'},
    {'code': 'UPG', 'city': 'Makassar (Sultan Hasanuddin)'},
    {'code': 'BDO', 'city': 'Bandung (Husein Sastranegara)'},
    {'code': 'SIN', 'city': 'Singapore (Changi)'},
    {'code': 'KUL', 'city': 'Kuala Lumpur (Malaysia)'},
    {'code': 'BKK', 'city': 'Bangkok (Thailand)'},
    {'code': 'ICN', 'city': 'Seoul (Incheon, South Korea)'},
    {'code': 'HND', 'city': 'Tokyo (Haneda, Japan)'},
    {'code': 'LHR', 'city': 'London (Heathrow, UK)'},
    {'code': 'JFK', 'city': 'New York (JFK, USA)'},
    {'code': 'DXB', 'city': 'Dubai (UAE)'},
    {'code': 'DOH', 'city': 'Doha (Qatar)'},
    {'code': 'SYD', 'city': 'Sydney (Australia)'},
  ];

  String? fromCode;
  String? toCode;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    fromCode = 'CGK';
    if (widget.preselectedDestination != null &&
        widget.preselectedDestination!.isNotEmpty) {
      toCode = widget.preselectedDestination;
    }
  }

  void swapAirports() {
    setState(() {
      final temp = fromCode;
      fromCode = toCode;
      toCode = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Search Flights",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: fromCode,
                    decoration: const InputDecoration(
                      labelText: 'Origin',
                      prefixIcon: Icon(Icons.flight_takeoff),
                      border: OutlineInputBorder(),
                    ),
                    items: airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['code'],
                            child: Text(a['city']!),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => fromCode = v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, color: Colors.teal),
                  onPressed: swapAirports,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: toCode,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      prefixIcon: Icon(Icons.flight_land),
                      border: OutlineInputBorder(),
                    ),
                    items: airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['code'],
                            child: Text(a['city']!),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => toCode = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Departure Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${selectedDate.toLocal()}".split(' ')[0]),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (fromCode == null || toCode == null)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlightDetailScreen(
                              origin: fromCode!,
                              destination: toCode!,
                              date: selectedDate,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Search Flights",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/home",
                  (route) => false,
                );
              },
              child: const Text(
                "Back to Home",
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// ===============    FLIGHT DETAIL SCREEN   ==============
// ========================================================

class FlightDetailScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final DateTime date;

  const FlightDetailScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
  });

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> flightList = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    fetchAmadeusFlights();
  }

  Future<void> fetchAmadeusFlights() async {
    try {
      final flights = await _apiService.searchFlights(
        origin: widget.origin,
        destination: widget.destination,
        departureDate: _formatDate(widget.date),
      );

      if (flights.isNotEmpty) {
        setState(() {
          flightList = flights.take(6).toList();
          _loading = false;
        });
      } else {
        _useDummy();
      }
    } catch (e) {
      _useDummy();
    }
  }

  void _useDummy() {
    flightList = List.generate(
      5,
      (i) => {
        "airline": "SkyHaven Air ${i + 1}",
        "time": "${8 + i}:00",
        "duration": "2h ${i * 10}m",
        "price": 850000 + i * 200000,
        "from": widget.origin,
        "to": widget.destination,
        "flightNo": "SH${100 + i}",
      },
    );

    setState(() {
      _loading = false;
      _error = true;
    });
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _formatIDR(num price) {
    final format = NumberFormat('#,###', 'id_ID');
    return "Rp ${format.format(price).replaceAll(',', '.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.origin} → ${widget.destination}"),
        backgroundColor: Colors.teal,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Departure: ${_formatDate(widget.date)}",
                  style: const TextStyle(color: Colors.black54),
                ),
                if (_error)
                  const Text(
                    "⚠ Showing dummy flights (API unavailable)",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                const SizedBox(height: 16),

                ...flightList.map((f) => _buildFlightCard(f)),
              ],
            ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> f) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black12.withOpacity(0.08)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            f["airline"] ?? "-",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${f["from"]} • ${f["time"]}"),
              const Icon(Icons.flight_takeoff, color: Colors.teal),
              Text("${f["to"]} • ${f["duration"]}"),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatIDR(f["price"]),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeatSelectionScreen(flightInfo: f),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
