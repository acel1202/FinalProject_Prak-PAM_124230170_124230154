// lib/service/flightapi_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:http/http.dart' as http;

/// Simple FlightAPI.io service wrapper.
/// Endpoint used: /onewaytrip/{API_KEY}/{FROM}/{TO}/{DATE}/{ADULTS}
class FlightApiConfig {
  static const String baseUrl = "https://api.flightapi.io";
  // <-- gunakan API key yang valid (kamu sebut 6923e792b8479235f239a7e1)
  static const String apiKey = "6923e792b8479235f239a7e1";
}

class FlightApiService {
  FlightApiService._private();
  static final FlightApiService instance = FlightApiService._private();

  final String base = FlightApiConfig.baseUrl;
  final String key = FlightApiConfig.apiKey;

  /// One-way search. Returns list of maps (raw normalization).
  Future<List<Map<String, dynamic>>> searchOneWay({
    required String origin, // IATA
    required String destination, // IATA
    required String departureDate, // yyyy-MM-dd
    int adults = 1,
  }) async {
    final url =
        "$base/onewaytrip/$key/$origin/$destination/$departureDate/$adults";
    try {
      debugPrint('FlightApiService: GET $url');
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 14));

      if (res.statusCode != 200) {
        debugPrint('FlightApiService non-200: ${res.statusCode} ${res.body}');
        return [];
      }

      final dynamic data = jsonDecode(res.body);

      // normalize various response shapes
      final List<Map<String, dynamic>> out = [];

      if (data == null) return out;

      // common: {"data": [ ... ]}
      if (data is Map && data['data'] is List) {
        for (var item in data['data']) {
          out.add(_toMap(item));
        }
        return out;
      }

      // sometimes a list at top
      if (data is List) {
        for (var item in data) {
          out.add(_toMap(item));
        }
        return out;
      }

      // other nested keys
      if (data is Map) {
        if (data['flights'] is List) {
          for (var item in data['flights']) out.add(_toMap(item));
          return out;
        }
        // search for first list value
        for (var v in data.values) {
          if (v is List) {
            for (var item in v) out.add(_toMap(item));
            if (out.isNotEmpty) return out;
          }
        }
      }

      return out;
    } catch (e, st) {
      debugPrint('FlightApiService exception: $e\n$st');
      return [];
    }
  }

  Map<String, dynamic> _toMap(dynamic f) {
    // Attempt to convert unknown structure to a map with common keys.
    try {
      if (f is Map<String, dynamic>) {
        final Map<String, dynamic> m = Map<String, dynamic>.from(f);
        // ensure some commonly expected fields
        return {
          'airline': m['airline'] is Map
              ? (m['airline']['name'] ?? m['airline'])
              : (m['airline'] ?? m['carrier'] ?? m['airline_name'] ?? ''),
          'logo': m['airline'] is Map
              ? (m['airline']['logo'] ?? '')
              : (m['logo'] ?? ''),
          'time': m['departure'] is Map
              ? (m['departure']['time'] ??
                    m['departure']['scheduledTime'] ??
                    '')
              : (m['departure_time'] ?? m['dep_time'] ?? m['time'] ?? ''),
          'departure': m['departure'] is Map
              ? (m['departure']['time'] ??
                    m['departure']['scheduledTime'] ??
                    '')
              : (m['departure_time'] ?? m['dep_time'] ?? ''),
          'arrival': m['arrival'] is Map
              ? (m['arrival']['time'] ?? m['arrival']['scheduledTime'] ?? '')
              : (m['arrival_time'] ?? m['arr_time'] ?? ''),
          'duration': m['duration'] ?? m['flight_time'] ?? '',
          'price': m['price'] is Map
              ? (m['price']['total'] ?? m['price']['value'] ?? m['price'])
              : (m['price'] ?? m['fare'] ?? m['cost'] ?? 0),
          'flightNo': m['flight'] is Map
              ? (m['flight']['number'] ?? m['flight']['flightNumber'] ?? '')
              : (m['flightNo'] ?? m['flight_number'] ?? ''),
          'cabin': m['class'] ?? m['cabin'] ?? '',
          'from': m['from'] ?? m['origin'] ?? '',
          'to': m['to'] ?? m['destination'] ?? '',
          'raw': m,
        };
      } else {
        return {'raw': f};
      }
    } catch (e) {
      debugPrint('toMap normalize error: $e');
      return {'raw': f};
    }
  }
}
