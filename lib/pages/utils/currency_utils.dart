// lib/utils/currency_utils.dart
class CurrencyUtils {
  // simple conversion table (IDR base). Expand if needed.
  static const Map<String, double> ratesToIDR = {
    'IDR': 1,
    'USD': 15000,
    'EUR': 16500,
    'JPY': 105,
    'CNY': 2200,
    'KRW': 13,
  };

  // convert from IDR to target currency (input price assumed IDR)
  static double convert(double amountInIDR, String from, String to) {
    if (from == to) return amountInIDR;
    final fromRate = ratesToIDR[from] ?? 1;
    final toRate = ratesToIDR[to] ?? 1;
    // amountInIDR / fromRate gives base units? simpler: treat "ratesToIDR" as 1 unit -> IDR value
    // We expect amountInIDR to be in IDR; if not, be careful.
    final amountInIDRValue = amountInIDR * (from == 'IDR' ? 1 : fromRate);
    final converted = amountInIDRValue / toRate;
    return converted.roundToDouble();
  }
}
