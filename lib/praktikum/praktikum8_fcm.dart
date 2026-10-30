import 'package:flutter/material.dart';

class Praktikum8Screen extends StatelessWidget {
  const Praktikum8Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Text('Praktikum 8: Push Notification (FCM)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Memerlukan file konfigurasi google-services.json dari Firebase Console.'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Langkah Inisialisasi Firebase:\n\n'
                '1. Firebase.initializeApp()\n'
                '2. FirebaseMessaging.instance.requestPermission()\n'
                '3. FirebaseMessaging.instance.getToken()\n'
                '4. FirebaseMessaging.onMessage.listen(...)',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
          )
        ],
      ),
    );
  }
}