// lib/utils/currency_utils.dart
class CurrencyUtils {
  // Konversi sederhana berbasis IDR
  static const Map<String, double> ratesToIDR = {
    'IDR': 1,
    'USD': 15000,
    'EUR': 16500,
    'JPY': 105,
    'CNY': 2200,
    'KRW': 13,
  };

  static double convert(double amountInIDR, String from, String to) {
    if (from == to) return amountInIDR;

    final fromRate = ratesToIDR[from] ?? 1;
    final toRate = ratesToIDR[to] ?? 1;

    final amountInIDRValue = amountInIDR * (from == 'IDR' ? 1 : fromRate);
    final converted = amountInIDRValue / toRate;
    return converted;
  }

  // Tambahan format — tidak mengubah logika lama
  static String formatCurrency(double value, String currency) {
    return "$currency ${value.toStringAsFixed(0)}";
  }
}
