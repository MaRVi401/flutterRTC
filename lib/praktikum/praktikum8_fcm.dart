import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Praktikum8Screen extends StatefulWidget {
  const Praktikum8Screen({super.key});

  @override
  State<Praktikum8Screen> createState() => _Praktikum8ScreenState();
}

class _Praktikum8ScreenState extends State<Praktikum8Screen> {
  String _fcmToken = 'Belum diinisialisasi';
  final List<String> _notificationLogs = [];
  bool _isLoading = false;

  Future<void> _initFCM() async {
    setState(() => _isLoading = true);
    try {
      // Inisialisasi Firebase
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;

      // Minta izin notifikasi ke sistem Android
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        setState(() {
          _fcmToken = token ?? 'Token FCM Kosong';
          _notificationLogs.insert(0, '[System]: Izin notifikasi diberikan.');
        });

        // Listener pesan foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (mounted) {
            setState(() {
              _notificationLogs.insert(
                0,
                '[Foreground FCM]: ${message.notification?.title ?? "Pesan"} - ${message.notification?.body ?? ""}',
              );
            });
          }
        });
      } else {
        setState(() {
          _notificationLogs.insert(0, '[System]: Izin notifikasi ditolak.');
        });
      }
    } catch (e) {
      // Jika Firebase Console belum di-setup penuh, jalankan mode simulasi
      setState(() {
        _fcmToken = 'SIMULATED_FCM_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
        _notificationLogs.insert(0, '[Simulasi FCM]: Mode pengujian interaktif aktif.');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _simulateIncomingNotification() {
    setState(() {
      _notificationLogs.insert(
        0,
        '[Pesan Masuk Dummy]: Pengujian Notifikasi FCM Berhasil! (${DateTime.now().valueToString()})',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _initFCM,
            icon: const Icon(Icons.notifications_active),
            label: Text(_isLoading ? 'Menginisialisasi...' : 'Inisialisasi & Ambil Token FCM'),
          ),
          const SizedBox(height: 12),
          const Text('FCM Registration Token:', style: TextStyle(fontWeight: FontWeight.bold)),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                _fcmToken,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _simulateIncomingNotification,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
            icon: const Icon(Icons.send),
            label: const Text('Simulasi Notifikasi Masuk'),
          ),
          const SizedBox(height: 12),
          const Text('Log Notifikasi:', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _notificationLogs.length,
              itemBuilder: (ctx, i) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(_notificationLogs[i], style: const TextStyle(fontSize: 12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension DateTimeFormatter on DateTime {
  String valueToString() => '$hour:$minute:$second';
}