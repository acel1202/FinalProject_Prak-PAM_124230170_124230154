// lib/pages/booking/pesawat/search_flight.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../models/flight_model.dart';
import '../../utils/currency_utils.dart';
import '../../utils/time_utils.dart';
import '../../payment/payment_screen.dart';
import 'booking_seat.dart';

enum FlightSort { none, cheapest, quickest, earliest }

// -----------------------
// Amadeus service (embedded here)
// -----------------------
class AmadeusConfig {
  // <-- Ganti dengan Amadeus sandbox credentials milikmu
  // contoh (jangan commit credentials ke repo publik):
  static const String clientId =
      "AyQFoXGIZUxg1taOJHWskK6GWIPslXI"; // <-- contoh: isi sesuai milikmu
  static const String clientSecret =
      "4pyONZrRJsF1mbOd"; // <-- contoh: isi sesuai milikmu

  // Base url sandbox:
  static const String base = "https://test.api.amadeus.com";
}

class AmadeusService {
  AmadeusService._private();
  static final AmadeusService instance = AmadeusService._private();

  String? _token;
  DateTime? _tokenExpiry;

  Future<String> _getToken() async {
    // reuse if still valid (5s buffer)
    if (_token != null && _tokenExpiry != null) {
      if (DateTime.now().isBefore(
        _tokenExpiry!.subtract(const Duration(seconds: 5)),
      )) {
        debugPrint('AmadeusService: using cached token');
        return _token!;
      }
    }

    final url = '${AmadeusConfig.base}/v1/security/oauth2/token';
    final body = {
      'grant_type': 'client_credentials',
      'client_id': AmadeusConfig.clientId,
      'client_secret': AmadeusConfig.clientSecret,
    };

    debugPrint('AmadeusService: requesting token from $url');
    try {
      final res = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: body,
          )
          .timeout(const Duration(seconds: 12));

      debugPrint('Amadeus token status: ${res.statusCode}');
      if (res.statusCode != 200) {
        throw Exception(
          'Failed to obtain Amadeus token: ${res.statusCode} ${res.body}',
        );
      }

      final Map<String, dynamic> data = jsonDecode(res.body);
      _token = data['access_token'];
      final int expiresIn = data['expires_in'] is int
          ? data['expires_in']
          : int.tryParse(data['expires_in']?.toString() ?? '0') ?? 0;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      debugPrint('AmadeusService: got token, expires in $expiresIn sec');
      return _token!;
    } catch (e) {
      debugPrint('AmadeusService token error: $e');
      rethrow;
    }
  }

  /// Search flight offers (Amadeus Flight Offers Search v2)
  /// This uses the POST /v2/shopping/flight-offers endpoint (sandbox).
  Future<List<Map<String, dynamic>>> searchOffers({
    required String origin,
    required String destination,
    required String departureDate, // yyyy-MM-dd
    int adults = 1,
    int max = 10,
  }) async {
    try {
      final token = await _getToken();
      final url = '${AmadeusConfig.base}/v2/shopping/flight-offers';
      final body = {
        "currency": "IDR",
        "originDestination": [
          {
            "id": "1",
            "originLocationCode": origin,
            "destinationLocationCode": destination,
            "originDate": {"date": departureDate},
          },
        ],
        "travelers": List.generate(
          adults,
          (i) => {"id": (i + 1).toString(), "travelerType": "ADULT"},
        ),
        "sources": [
          "GDS",
        ], // sandbox might accept this; adjust if provider expects different
        "searchCriteria": {"maxFlightOffers": max},
      };

      debugPrint('AmadeusService: POST $url with body -> ${jsonEncode(body)}');
      final res = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 14));

      debugPrint('Amadeus offers status ${res.statusCode}');
      if (res.statusCode != 200 && res.statusCode != 201) {
        debugPrint('Amadeus response: ${res.body}');
        throw Exception('Amadeus search error: ${res.statusCode} ${res.body}');
      }

      final Map<String, dynamic> data = jsonDecode(res.body);
      final List<Map<String, dynamic>> out = [];

      if (data['data'] is List) {
        for (var offer in data['data']) {
          final normalized = _normalizeOffer(offer, origin, destination);
          out.add(normalized);
        }
      }

      return out;
    } catch (e) {
      debugPrint('AmadeusService.searchOffers exception: $e');
      return [];
    }
  }

  Map<String, dynamic> _normalizeOffer(
    dynamic offer,
    String origin,
    String destination,
  ) {
    try {
      // Offer shape from Amadeus v2: itineraries -> segments; price -> total etc.
      String airline = '';
      String departure = '';
      String arrival = '';
      String duration = '';
      String flightNo = '';
      double price = 0.0;
      String cabin = '';

      // price
      if (offer is Map && offer['price'] != null) {
        final p = offer['price'];
        price =
            double.tryParse(
              (p['grandTotal'] ?? p['total'] ?? p['currencyAmount'] ?? '')
                  .toString()
                  .replaceAll(',', ''),
            ) ??
            (double.tryParse(
                  (p['total'] ?? p['grandTotal'] ?? '0').toString(),
                ) ??
                0.0);
      }

      // itinerary first
      if (offer is Map &&
          offer['itineraries'] is List &&
          offer['itineraries'].isNotEmpty) {
        final it = offer['itineraries'][0];
        // duration
        duration = it['duration'] ?? '';
        if (it['segments'] is List && it['segments'].isNotEmpty) {
          final seg = it['segments'][0];
          // departure / arrival ISO
          if (seg['departure'] is Map && seg['departure']['at'] != null) {
            departure = seg['departure']['at'];
          } else {
            departure = seg['departure_time'] ?? '';
          }
          if (seg['arrival'] is Map && seg['arrival']['at'] != null) {
            arrival = seg['arrival']['at'];
          } else {
            arrival = seg['arrival_time'] ?? '';
          }

          final carrier = seg['carrierCode'] ?? seg['carrier'] ?? '';
          final number = seg['number'] ?? seg['flightNumber'] ?? '';
          flightNo = (carrier.toString() + (number?.toString() ?? ''))
              .toString();

          // airline name fallback
          airline =
              seg['carrierCode'] ?? seg['operating']?['carrierCode'] ?? '';
          cabin = seg['cabin'] ?? seg['fareClass'] ?? '';
        }
      }

      return {
        'airline': airline.toString(),
        'from': origin,
        'to': destination,
        'flightNo': flightNo,
        'departure': departure,
        'arrival': arrival,
        'duration': duration ?? '',
        'price': price,
        'cabin': cabin ?? '',
        'raw': offer,
      };
    } catch (e) {
      debugPrint('Amadeus normalize error: $e');
      return {'raw': offer};
    }
  }
}

// -----------------------
// Main UI file (unchanged UI: search_flight.dart) but wired to AmadeusService
// -----------------------
class SearchFlightScreen extends StatefulWidget {
  const SearchFlightScreen({super.key});

  @override
  State<SearchFlightScreen> createState() => _SearchFlightScreenState();
}

class _SearchFlightScreenState extends State<SearchFlightScreen> {
  // using AmadeusService directly instead of external controller (so you don't need to change other files)
  final AmadeusService _amadeus = AmadeusService.instance;

  final Map<String, String> airports = {
    'CGK': 'Jakarta (CGK)',
    'DPS': 'Bali (DPS)',
    'SUB': 'Surabaya (SUB)',
    'KNO': 'Medan (KNO)',
    'UPG': 'Makassar (UPG)',
    'BDO': 'Bandung (BDO)',
    'SIN': 'Singapore (SIN)',
    'KUL': 'Kuala Lumpur (KUL)',
    'HND': 'Tokyo (HND)',
    'BKK': 'Bangkok (BKK)',
  };

  String? origin = 'CGK';
  String? destination = 'DPS';
  DateTime date = DateTime.now().add(const Duration(days: 7));
  String tz = 'WIB';
  String currency = 'IDR';
  FlightSort sort = FlightSort.none;

  bool loading = false;
  List<FlightModel> flights = [];
  bool recLoading = true;
  List<Map<String, dynamic>> recommended = [];

  @override
  void initState() {
    super.initState();
    _loadRecommended();
    // don't auto-search on init
  }

  Future<void> _loadRecommended() async {
    setState(() => recLoading = true);
    await Future.delayed(const Duration(milliseconds: 250));
    recommended = [
      {'dest': 'DPS - Bali', 'price': 750000},
      {'dest': 'SIN - Singapore', 'price': 1500000},
      {'dest': 'KUL - Kuala Lumpur', 'price': 1200000},
    ];
    if (!mounted) return;
    setState(() => recLoading = false);
  }

  Future<void> _search() async {
    if (origin == null || destination == null) return;
    if (origin == destination) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Origin and destination must differ")),
      );
      return;
    }

    setState(() {
      loading = true;
      flights = [];
    });

    try {
      final dateStr = TimeUtils.formatDate(date);
      debugPrint(
        '🔎 Amadeus Searching flights: $origin -> $destination @ $dateStr',
      );

      final raw = await _amadeus.searchOffers(
        origin: origin!,
        destination: destination!,
        departureDate: dateStr,
        adults: 1,
        max: 10,
      );

      debugPrint('🔔 Amadeus returned ${raw.length} offers');

      // convert normalized maps to FlightModel
      final List<FlightModel> parsed = raw.map<FlightModel>((m) {
        final mutable = Map<String, dynamic>.from(m);
        // fallback: if departure empty but raw data has deep times, try to extract
        if ((mutable['departure'] ?? '').toString().isEmpty) {
          // try to read from raw if present
          final rawOffer = mutable['raw'];
          if (rawOffer is Map &&
              rawOffer['itineraries'] is List &&
              rawOffer['itineraries'].isNotEmpty) {
            try {
              final seg = rawOffer['itineraries'][0]['segments'][0];
              mutable['departure'] =
                  seg['departure']?['at'] ?? seg['departure_time'] ?? '';
            } catch (_) {}
          }
        }
        // ensure price numeric
        if (mutable['price'] is String) {
          mutable['price'] =
              double.tryParse(
                mutable['price'].toString().replaceAll(',', ''),
              ) ??
              0.0;
        }
        return FlightModel.fromMap(mutable);
      }).toList();

      if (!mounted) return;
      setState(() {
        flights = parsed;
        loading = false;
      });

      if (flights.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No flights found for selected route/date"),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Amadeus search error: $e');
      if (!mounted) return;
      setState(() => loading = false);
      // show helpful message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    }
  }

  void _applySort() {
    if (sort == FlightSort.none) return;

    if (sort == FlightSort.cheapest) {
      flights.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == FlightSort.quickest) {
      int durToMin(String s) {
        final h = RegExp(r'(\d+)H', caseSensitive: false).firstMatch(s);
        final m = RegExp(r'(\d+)M', caseSensitive: false).firstMatch(s);
        final hh = int.tryParse(h?.group(1) ?? '0') ?? 0;
        final mm = int.tryParse(m?.group(1) ?? '0') ?? 0;
        return hh * 60 + mm;
      }

      flights.sort(
        (a, b) => durToMin(a.duration).compareTo(durToMin(b.duration)),
      );
    } else if (sort == FlightSort.earliest) {
      flights.sort((a, b) {
        final t1 = TimeUtils.tryParseAny(a.departure);
        final t2 = TimeUtils.tryParseAny(b.departure);
        return t1.compareTo(t2);
      });
    }
  }

  String _displayTime(FlightModel f) {
    try {
      final dt = TimeUtils.tryParseAny(f.departure);
      return "${DateFormat('yyyy-MM-dd HH:mm').format(dt)} ($tz)";
    } catch (_) {
      return f.departure;
    }
  }

  String _formatIDR(num value) {
    final f = NumberFormat('#,###', 'id_ID');
    return "Rp ${f.format(value).replaceAll(',', '.')}";
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Where do you want to go?",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const Text(
            "Find Flights",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => _buildSearchPanel(),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Row(
                children: const [
                  Icon(Icons.flight_takeoff, color: Colors.deepPurple),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Find Flights",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.deepPurple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 12,
          children: [
            const Text(
              "Search Flight",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              value: origin,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Origin",
              ),
              items: airports.keys
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text("$c - ${airports[c]}"),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => origin = v),
            ),
            DropdownButtonFormField<String>(
              value: destination,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Destination",
              ),
              items: airports.keys
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text("$c - ${airports[c]}"),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => destination = v),
            ),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => date = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Departure Date",
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(TimeUtils.formatDate(date)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: tz,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Timezone",
                    ),
                    items: ['WIB', 'WITA', 'WIT', 'London']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => tz = v ?? tz),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: currency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Currency",
                    ),
                    items: CurrencyUtils.ratesToIDR.keys
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => currency = v ?? currency),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _search();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Search"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommended(double fullWidth) {
    if (recLoading) return const Center(child: CircularProgressIndicator());
    if (recommended.isEmpty) return const SizedBox.shrink();

    final cardWidth = (fullWidth - 48) * 0.6;

    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: recommended.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = recommended[i];
          return SizedBox(
            width: cardWidth.clamp(160.0, fullWidth * 0.82),
            child: GestureDetector(
              onTap: () {
                final code = item['dest'].split(' - ').first;
                setState(() => destination = code);
                _search();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['dest'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      'Est. Rp ${NumberFormat('#,###').format(item['price']).replaceAll(',', '.')}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Best'),
                    selected: sort == FlightSort.none,
                    onSelected: (_) => setState(() {
                      sort = FlightSort.none;
                      _applySort();
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Cheapest'),
                    selected: sort == FlightSort.cheapest,
                    onSelected: (_) => setState(() {
                      sort = FlightSort.cheapest;
                      _applySort();
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Quickest'),
                    selected: sort == FlightSort.quickest,
                    onSelected: (_) => setState(() {
                      sort = FlightSort.quickest;
                      _applySort();
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Earliest'),
                    selected: sort == FlightSort.earliest,
                    onSelected: (_) => setState(() {
                      sort = FlightSort.earliest;
                      _applySort();
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (loading)
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    if (flights.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No flights found')),
      );

    return Column(
      children: flights.map((f) {
        final conv = CurrencyUtils.convert(f.price, 'IDR', currency);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingSummaryPage(
                    bookingId: const Uuid().v4(),
                    flight: f.toMap(),
                    totalAmount: f.price,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.flight, size: 40, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${f.airline} • ${f.flightNo}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${f.from} → ${f.to}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_displayTime(f)} • ${f.duration}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$currency ${NumberFormat('#,###').format(conv)}',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookingSeatPage(flight: f.toMap()),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 18),
              children: [
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recommended Destinations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: _buildRecommended(fullWidth),
                ),
                const SizedBox(height: 18),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildResults(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _search,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/// BookingSummaryPage (simple) -> PaymentScreen
class BookingSummaryPage extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> flight;
  final double totalAmount;

  const BookingSummaryPage({
    super.key,
    required this.bookingId,
    required this.flight,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final airline = flight['airline'] ?? 'Unknown';
    final dep = flight['departure'] ?? '-';
    final from = flight['from'] ?? '-';
    final to = flight['to'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              airline,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Departure: $dep'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.03),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.black54)),
                  Text(
                    NumberFormat(
                      '#,###',
                      'id_ID',
                    ).format(totalAmount).replaceAll(',', '.'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        bookingId: bookingId,
                        baseAmount: totalAmount,
                        flightFrom: from,
                        flightTo: to,
                        departure: dep,
                        airline: airline,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B63B5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
