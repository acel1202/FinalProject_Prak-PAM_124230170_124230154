// lib/models/flight_model.dart
class FlightModel {
  final String airline;
  final String from;
  final String to;
  final String flightNo;
  final String departure; // ISO or time string
  final String arrival;
  final String duration;
  final double price;
  final String cabin;
  final Map<String, dynamic>? raw;

  FlightModel({
    required this.airline,
    required this.from,
    required this.to,
    required this.flightNo,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.price,
    this.cabin = 'ECONOMY',
    this.raw,
  });

  factory FlightModel.fromMap(Map<String, dynamic> m) {
    return FlightModel(
      airline: (m['airline'] ?? m['airlineName'] ?? 'Unknown Airline')
          .toString(),
      from: (m['from'] ?? m['origin'] ?? '').toString(),
      to: (m['to'] ?? m['destination'] ?? '').toString(),
      flightNo: (m['flightNo'] ?? m['flight_number'] ?? m['flight'] ?? '')
          .toString(),
      departure: (m['departure'] ?? m['dep_time'] ?? m['departure_time'] ?? '')
          .toString(),
      arrival: (m['arrival'] ?? m['arr_time'] ?? m['arrival_time'] ?? '')
          .toString(),
      duration: (m['duration'] ?? m['flight_time'] ?? '').toString(),
      price: _toDoubleSafe(m['price'] ?? m['fare'] ?? m['cost'] ?? 0),
      cabin: (m['cabin'] ?? m['class'] ?? 'ECONOMY').toString(),
      raw: m['raw'] is Map
          ? Map<String, dynamic>.from(m['raw'])
          : (m['raw'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'airline': airline,
      'from': from,
      'to': to,
      'flightNo': flightNo,
      'departure': departure,
      'arrival': arrival,
      'duration': duration,
      'price': price,
      'cabin': cabin,
      'raw': raw,
    };
  }

  static double _toDoubleSafe(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    final s = v.toString();
    final cleaned = s.replaceAll(RegExp('[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
