// lib/utils/time_utils.dart
class TimeUtils {
  static String formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  // Convert time string between WIB/WITA/WIT/London approximation (no timezone conversion library)
  // This is a simple offset-based conversion for display (WIB = UTC+7, WITA = UTC+8, WIT = UTC+9, London = UTC+0/UTC+1)
  static DateTime tryParseAny(String s, {DateTime? fallback}) {
    try {
      return DateTime.parse(s);
    } catch (_) {
      // fallback: if format hh:mm or HH:mm:ss
      try {
        final parts = s.split(':');
        final h = int.tryParse(parts[0]) ?? 0;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, h, m);
      } catch (_) {
        return fallback ?? DateTime.now();
      }
    }
  }
}
