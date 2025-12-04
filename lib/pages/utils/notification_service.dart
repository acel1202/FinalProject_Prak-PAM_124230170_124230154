import 'package:flutter/material.dart'; // <-- tambahkan ini
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'booking_channel',
        channelName: 'Booking',
        channelDescription: 'Notifikasi untuk status booking hotel',
        importance: NotificationImportance.Max,
        defaultColor: const Color(0xFFFFB45F),
        ledColor: const Color(0xFFFFB45F),
      ),
    ], debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> showBookingSuccess({
    required String hotelName,
    required double totalPrice,
    required String currency,
  }) async {
    final title = 'Booking Berhasil';
    final body =
        'Hotel $hotelName berhasil dipesan. Total: $currency ${totalPrice.toStringAsFixed(0)}';

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'booking_channel',
        title: title,
        body: body,
      ),
    );
  }
}
