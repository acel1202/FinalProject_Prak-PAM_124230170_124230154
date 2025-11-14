// lib/pages/booking/booking_pesawat.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// pastikan path sesuai struktur proyekmu
import '../../../service/api_amadeus_service.dart';
import '../../payment/payment_screen.dart';

/// ======================================================================
///                      Search Flight Page
/// ======================================================================
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
    {'code': 'JFK', 'city': 'New York (John F. Kennedy, USA)'},
    {'code': 'DXB', 'city': 'Dubai (UAE)'},
    {'code': 'DOH', 'city': 'Doha (Qatar)'},
    {'code': 'SYD', 'city': 'Sydney (Australia)'},
  ];

  String? fromCode;
  String? toCode;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
  String fromTimeZone = 'WIB';
  String toTimeZone = 'WITA';

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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Search Flights',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: fromCode,
                    decoration: const InputDecoration(
                      labelText: 'Origin',
                      prefixIcon: Icon(Icons.flight_takeoff),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['code'],
                            child: Text(
                              a['city']!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => fromCode = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: IconButton(
                    icon: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.teal,
                      size: 28,
                    ),
                    tooltip: 'Swap',
                    onPressed: swapAirports,
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: toCode,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      prefixIcon: Icon(Icons.flight_land),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['code'],
                            child: Text(
                              a['city']!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => toCode = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    Text(
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: fromTimeZone,
                  items: const [
                    DropdownMenuItem(value: 'WIB', child: Text('WIB')),
                    DropdownMenuItem(value: 'WITA', child: Text('WITA')),
                    DropdownMenuItem(value: 'WIT', child: Text('WIT')),
                    DropdownMenuItem(value: 'London', child: Text('London')),
                  ],
                  onChanged: (v) => setState(() => fromTimeZone = v!),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.compare_arrows),
                ),
                DropdownButton<String>(
                  value: toTimeZone,
                  items: const [
                    DropdownMenuItem(value: 'WIB', child: Text('WIB')),
                    DropdownMenuItem(value: 'WITA', child: Text('WITA')),
                    DropdownMenuItem(value: 'WIT', child: Text('WIT')),
                    DropdownMenuItem(value: 'London', child: Text('London')),
                  ],
                  onChanged: (v) => setState(() => toTimeZone = v!),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Search Flights',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_outlined, color: Colors.teal),
                label: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================================================================
///                      Flight Detail Screen
/// ======================================================================
class FlightDetailScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final DateTime date;
  final String? tzFrom;
  final String? tzTo;
  final List<Map<String, dynamic>>? flights;

  const FlightDetailScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
    this.tzFrom,
    this.tzTo,
    this.flights,
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
    if (widget.flights != null && widget.flights!.isNotEmpty) {
      flightList = widget.flights!;
      _loading = false;
    } else {
      fetchAmadeusFlights();
    }
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
          _error = false;
        });
      } else {
        _useDummyData();
      }
    } catch (e) {
      _useDummyData();
    }
  }

  String _formatIDR(num value) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(value).replaceAll(',', '.')}';
  }

  void _useDummyData() {
    flightList = List.generate(
      5,
      (i) => {
        'airline': 'SkyHaven Air ${i + 1}',
        'logo': '',
        'time': '${8 + i}:00',
        'duration': '2h ${i * 10}m',
        'price': 850000 + i * 200000,
        'flightNo': 'SH${100 + i}',
        'cabin': 'ECONOMY',
        'from': widget.origin,
        'to': widget.destination,
      },
    );
    setState(() {
      _loading = false;
      _error = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '${widget.origin} → ${widget.destination}',
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : flightList.isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                for (var f in flightList) _buildFlightCard(context, f),
              ],
            ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.origin} → ${widget.destination}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          'Departure: ${_formatDate(widget.date)}',
          style: const TextStyle(color: Colors.black54),
        ),
        if (_error)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              '⚠️ Showing dummy flights (API unavailable)',
              style: TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
      ],
    ),
  );

  Widget _buildFlightCard(BuildContext context, Map<String, dynamic> f) {
    final airline = f['airline'] ?? 'Unknown Airline';
    final logo = f['logo'] ?? '';
    final price = f['price'] ?? 0;
    final from = f['from'] ?? widget.origin;
    final to = f['to'] ?? widget.destination;
    final time = f['time'] ?? f['departure_time'] ?? '—';
    final duration = f['duration'] ?? '—';
    final flightNo = f['flightNo'] ?? '';
    final cabin = f['cabin'] ?? 'ECONOMY';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              logo.isNotEmpty
                  ? Image.network(
                      logo,
                      width: 28,
                      height: 28,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.flight_takeoff,
                        color: Colors.teal,
                        size: 26,
                      ),
                    )
                  : const Icon(
                      Icons.flight_takeoff,
                      color: Colors.teal,
                      size: 26,
                    ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  airline,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(flightNo, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _formatTime(time),
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_right_alt_rounded,
                size: 28,
                color: Colors.teal,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      to,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      duration,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatIDR(
                  price is num ? price : double.tryParse(price.toString()) ?? 0,
                ),
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingFormScreen(
                        flight: {
                          'airline': airline,
                          'from': from,
                          'to': to,
                          'departure': _formatTime(time),
                          'price': price,
                          'cabin': cabin,
                          'raw': f,
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Padding(
      padding: EdgeInsets.only(top: 100),
      child: Text(
        'No flights found 🛫',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    ),
  );

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(String time) {
    if (time.isEmpty || time == '—') return '—';
    try {
      final dateTime = DateTime.parse(time);
      return DateFormat.Hm().format(dateTime);
    } catch (_) {
      return time;
    }
  }
}

/// ======================================================================
///                      Booking Form Screen
/// ======================================================================
class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? flight;
  const BookingFormScreen({super.key, this.flight});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int _passengers = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectSeats() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final flight = widget.flight ?? {};

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SeatSelectionScreen(
          flightInfo: {
            'from': flight['from'] ?? 'CGK',
            'to': flight['to'] ?? 'DPS',
            'departure':
                flight['departure'] ?? DateTime.now().toIso8601String(),
            'passenger_name': _nameController.text.trim(),
            'passenger_email': _emailController.text.trim(),
            'passenger_phone': _phoneController.text.trim(),
            'price': flight['price'] ?? 0,
            'airline': flight['airline'] ?? 'SkyHaven Air',
            'passengers': _passengers,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight ?? {};
    final route = '${flight['from'] ?? 'CGK'} → ${flight['to'] ?? 'DPS'}';
    final date = flight['departure'] ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1E),
      appBar: AppBar(
        title: const Text('Passenger Details'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date.toString(),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF1C2235),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF1C2235),
                        ),
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'Enter valid email'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF1C2235),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Enter valid phone'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Passengers',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<int>(
                            value: _passengers,
                            dropdownColor: const Color(0xFF1C2235),
                            items: List.generate(6, (i) => i + 1)
                                .map(
                                  (n) => DropdownMenuItem(
                                    value: n,
                                    child: Text(
                                      '$n',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _passengers = v ?? 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _selectSeats,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Continue to Seat Selection',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ======================================================================
///                      Seat Selection Screen
/// ======================================================================
class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> flightInfo;

  const SeatSelectionScreen({super.key, required this.flightInfo});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int rows = 10;
  final int cols = 6;
  final Set<String> selectedSeats = {};

  bool _loading = false;
  bool _seatLoading = false; // no DB load, seats always available
  String _seatClass = 'Economy';

  final Map<String, double> classMultiplier = {
    'Economy': 1.0,
    'Business': 1.6,
    'First Class': 2.3,
  };

  double get basePrice {
    final p = widget.flightInfo['price'];
    if (p is num) return p.toDouble();
    if (p is String) {
      final cleaned = p.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  int get passengerCount => (widget.flightInfo['passengers'] ?? 1).toInt();

  double get totalPrice =>
      basePrice * passengerCount * (classMultiplier[_seatClass] ?? 1.0);

  @override
  void initState() {
    super.initState();
    // No DB/session: seats are all available by default
  }

  Future<void> _proceedToPayment() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your seat(s)')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final bookingId = const Uuid().v4();

      // No DB insert or session usage — directly navigate to payment
      if (!mounted) return;
      setState(() => _loading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            bookingId: bookingId,
            baseAmount: totalPrice,
            flightFrom: widget.flightInfo['from'] ?? 'CGK',
            flightTo: widget.flightInfo['to'] ?? 'DPS',
            departure: widget.flightInfo['departure'] ?? '—',
            airline: widget.flightInfo['airline'] ?? 'SkyHaven Air',
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Booking proceed error: $e');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildSeat(String id) {
    final isSelected = selectedSeats.contains(id);

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isSelected) {
      bgColor = Colors.teal;
      borderColor = Colors.teal.shade700;
      textColor = Colors.white;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
      textColor = Colors.black87;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(id);
          } else {
            if (selectedSeats.length < passengerCount) {
              selectedSeats.add(id);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Max $passengerCount seats allowed'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          id,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from = widget.flightInfo['from'] ?? 'CGK';
    final to = widget.flightInfo['to'] ?? 'DPS';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Select Seats ($from → $to)',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _seatLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Select up to $passengerCount seat(s)',
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.teal, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _seatClass,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.teal,
                        ),
                        style: const TextStyle(color: Colors.black87),
                        onChanged: (v) {
                          setState(() => _seatClass = v!);
                        },
                        items: classMultiplier.keys.map((cls) {
                          return DropdownMenuItem(value: cls, child: Text(cls));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: List.generate(rows, (r) {
                        final letter = String.fromCharCode(65 + r);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            cols,
                            (c) => _buildSeat('$letter${c + 1}'),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Total: Rp ${totalPrice.toStringAsFixed(0)} ($_seatClass)',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Proceed to Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
