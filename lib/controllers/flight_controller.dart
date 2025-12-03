// lib/controllers/flight_controller.dart
import 'package:flutter/foundation.dart';
import '../models/flight_model.dart';
import '../service/amadeus_service.dart';

class FlightController {
  FlightController._private();
  static final FlightController instance = FlightController._private();

  final FlightApiService _service = FlightApiService.instance;

  /// Search wrapper: returns List<FlightModel>
  Future<List<FlightModel>> search(
    String origin,
    String destination,
    String date, {
    int adults = 1,
  }) async {
    try {
      debugPrint('FlightController.search -> $origin -> $destination @ $date');
      final raw = await _service.searchOneWay(
        origin: origin,
        destination: destination,
        departureDate: date,
        adults: adults,
      );

      final List<FlightModel> out = [];
      for (var m in raw) {
        final map = Map<String, dynamic>.from(m);
        // fill missing from/to if absent
        if ((map['from'] ?? '').toString().isEmpty) map['from'] = origin;
        if ((map['to'] ?? '').toString().isEmpty) map['to'] = destination;

        // if departure empty, try `time` key
        if ((map['departure'] ?? '').toString().isEmpty &&
            (map['time'] ?? '').toString().isNotEmpty) {
          map['departure'] = map['time'];
        }

        // price normalization fallback
        if (map['price'] == null || map['price'].toString().isEmpty) {
          map['price'] = 0;
        }

        out.add(FlightModel.fromMap(map));
      }

      debugPrint('FlightController.search normalized -> ${out.length} items');
      return out;
    } catch (e, st) {
      debugPrint('FlightController.search exception: $e\n$st');
      return [];
    }
  }
}
