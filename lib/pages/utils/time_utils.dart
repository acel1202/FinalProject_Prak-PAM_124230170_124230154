// lib/utils/time_utils.dart
class TimeUtils {
  static String formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static DateTime tryParseAny(String s, {DateTime? fallback}) {
    try {
      return DateTime.parse(s);
    } catch (_) {
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
