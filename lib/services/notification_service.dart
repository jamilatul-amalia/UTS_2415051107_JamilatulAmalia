import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Meminta izin notifikasi dan mengembalikan statusnya:
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  /// Mendapatkan FCM Token perangkat/browser
  Future<String?> getToken() async {
    final token = await _messaging.getToken(
      // Jika dijalankan di Web dan gagal mengambil token, isi vapidKey di bawah ini:
      // vapidKey: 'ISI_VAPID_KEY_DARI_FIREBASE_CONSOLE_JIKA_PERLU',
    );
    debugPrint('FCM Token: $token');
    return token;
  }

  /// Mendengarkan pembaruan token
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }
}