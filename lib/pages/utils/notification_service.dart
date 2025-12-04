// lib/pages/utils/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

 
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings);

    
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // NOTIFIKASI SUKSES BOOKING
  static Future<void> showBookingSuccess({
    required String hotelName,
    required double totalPrice,
    required String currency,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'booking_channel', 
      'Booking',        
      channelDescription: 'Notifikasi untuk status booking hotel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = 'Booking Berhasil';
    final body =
        'Hotel $hotelName berhasil dipesan. Total: $currency ${totalPrice.toStringAsFixed(0)}';

    await _plugin.show(
      0,      // id notifikasi
      title,  // judul
      body,   // isi
      notifDetails,
    );
  }
}
