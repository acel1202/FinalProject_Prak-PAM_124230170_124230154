import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_amadeus_config.dart';

class ApiService {
  String? _accessToken;

  Future<void> _getAccessToken() async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/v1/security/oauth2/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "client_credentials",
        "client_id": ApiConfig.apiKey,
        "client_secret": ApiConfig.apiSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data["access_token"];
    } else {
      throw Exception("❌ Gagal mendapatkan access token: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
  }) async {
    if (_accessToken == null) await _getAccessToken();

    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/v2/shopping/flight-offers"
      "?originLocationCode=$origin"
      "&destinationLocationCode=$destination"
      "&departureDate=$departureDate"
      "&adults=1&max=10&nonStop=false",
    );

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $_accessToken"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> flights = data["data"] ?? [];

      return flights.map<Map<String, dynamic>>((f) {
        try {
          final segment = f["itineraries"][0]["segments"][0];
          final carrier = segment["carrierCode"] ?? "XX";
          final airlineName = _airlineNames[carrier] ?? carrier;
          final aircraftCode = segment["aircraft"]?["code"] ?? "";
          final aircraftDisplay = aircraftCode.isNotEmpty
              ? "$airlineName • $aircraftCode"
              : airlineName;
          final flightNo = segment["number"] ?? "-";
          final departure = segment["departure"]["at"] ?? "";
          final arrival = segment["arrival"]["at"] ?? "";
          final duration = f["itineraries"][0]["duration"] ?? "";
          final priceBase =
              double.tryParse(
                f["price"]["base"] ?? f["price"]["total"] ?? "0",
              ) ??
              0.0;
          final priceTotal = (priceBase * 16000);
          String cabin = "ECONOMY";
          try {
            final travelerPricing = f["travelerPricings"][0];
            cabin =
                travelerPricing["fareDetailsBySegment"][0]["cabin"] ??
                "ECONOMY";
          } catch (_) {}
          return {
            "airline": aircraftDisplay,
            "flightNo": "$carrier$flightNo",
            "time": departure,
            "arrival": arrival,
            "duration": duration,
            "price": priceTotal,
            "cabin": cabin,
            "raw": f,
          };
        } catch (e) {
          return {
            "airline": "SkyHaven Air",
            "flightNo": "—",
            "time": "—",
            "arrival": "—",
            "duration": "—",
            "price": 0,
            "cabin": "ECONOMY",
          };
        }
      }).toList();
    } else if (response.statusCode == 401) {
      await _getAccessToken();
      return searchFlights(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
      );
    } else {
      throw Exception(
        "❌ Gagal memuat data penerbangan: ${response.statusCode} - ${response.body}",
      );
    }
  }

  Future<double> getSeatPricing(
    Map<String, dynamic> flightOffer, {
    String seatClass = "ECONOMY",
  }) async {
    if (_accessToken == null) await _getAccessToken();

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/v1/shopping/flight-offers/pricing",
    );

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "data": {
          "type": "flight-offers-pricing",
          "flightOffers": [flightOffer],
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final price =
          data["data"]?["flightOffers"]?[0]?["price"]?["total"] ?? "0";
      final double finalPrice = (double.tryParse(price) ?? 0.0) * 16000;
      return finalPrice;
    } else {
      throw Exception(
        "❌ Gagal mendapatkan seat pricing: ${response.statusCode} - ${response.body}",
      );
    }
  }

  Future<List<Map<String, dynamic>>> exploreDepartures({
    required String origin,
  }) async {
    if (_accessToken == null) await _getAccessToken();

    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/v1/shopping/flight-destinations"
      "?origin=$origin&maxPrice=20000000",
    );

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $_accessToken"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> flights = data["data"] ?? [];

      return flights.map<Map<String, dynamic>>((f) {
        return {
          "destination": f["destination"] ?? "-",
          "price": f["price"]["total"] ?? "0",
          "departureDate": f["departureDate"] ?? "-",
        };
      }).toList();
    } else if (response.statusCode == 401) {
      await _getAccessToken();
      return exploreDepartures(origin: origin);
    } else {
      throw Exception(
        "❌ Gagal memuat data eksplorasi: ${response.statusCode} - ${response.body}",
      );
    }
  }

  Future<Map<String, dynamic>?> getAirportLocation(String iataCode) async {
    if (_accessToken == null) await _getAccessToken();
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/v1/reference-data/locations?subType=AIRPORT&keyword=$iataCode",
    );
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $_accessToken"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data["data"];
      if (results.isNotEmpty) {
        final airport = results[0];
        final geo = airport["geoCode"];
        return {
          "name": airport["name"] ?? iataCode,
          "city": airport["address"]["cityName"] ?? "-",
          "lat": geo["latitude"],
          "lng": geo["longitude"],
        };
      }
    }
    return null;
  }
}

final Map<String, String> _airlineNames = {
  "GA": "Garuda Indonesia",
  "SQ": "Singapore Airlines",
  "MH": "Malaysia Airlines",
  "QF": "Qantas Airways",
  "JL": "Japan Airlines",
  "NH": "All Nippon Airways",
  "CX": "Cathay Pacific",
  "CI": "China Airlines",
  "PR": "Philippine Airlines",
  "BR": "EVA Air",
  "QR": "Qatar Airways",
  "EK": "Emirates",
  "EY": "Etihad Airways",
  "BA": "British Airways",
  "AF": "Air France",
  "LH": "Lufthansa",
  "AA": "American Airlines",
  "DL": "Delta Air Lines",
  "UA": "United Airlines",
  "FY": "Firefly",
  "OD": "Batik Air Malaysia",
  "JT": "Lion Air",
  "QZ": "Indonesia AirAsia",
  "TR": "Scoot",
  "KC": "Air Astana",
  "WY": "Oman Air",
  "SU": "Aeroflot",
};
