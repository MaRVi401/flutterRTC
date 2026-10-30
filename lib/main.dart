import 'package:flutter/material.dart';
import 'praktikum/praktikum1_rest.dart';
import 'praktikum/praktikum2_polling.dart';
import 'praktikum/praktikum3_sse.dart';
import 'praktikum/praktikum4_websocket.dart';
import 'praktikum/praktikum5_mqtt.dart';
import 'praktikum/praktikum6_webrtc.dart';
import 'praktikum/praktikum7_grpc.dart';
import 'praktikum/praktikum8_fcm.dart';

void main() {
  runApp(const RealtimeCommunicationApp());
}

class RealtimeCommunicationApp extends StatelessWidget {
  const RealtimeCommunicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Communication Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

// Model data sederhana untuk menu praktikum
class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

// Variabel Top-Level Constant (di luar class) agar tidak bentrok dengan StatelessWidget
final List<MenuItem> menuItems = const [
  MenuItem(
    title: 'Praktikum 1 — REST API',
    subtitle: 'Request–Response HTTP (GET/POST)',
    icon: Icons.http,
    color: Colors.blue,
    screen: Praktikum1Screen(),
  ),
  MenuItem(
    title: 'Praktikum 2 — Polling',
    subtitle: 'Periodic Request & Long Polling',
    icon: Icons.timer,
    color: Colors.orange,
    screen: Praktikum2Screen(),
  ),
  MenuItem(
    title: 'Praktikum 3 — SSE',
    subtitle: 'Server-Sent Events (Streaming 1 Arah)',
    icon: Icons.stream,
    color: Colors.teal,
    screen: Praktikum3Screen(),
  ),
  MenuItem(
    title: 'Praktikum 4 — WebSocket',
    subtitle: 'Komunikasi Dua Arah (Bidirectional)',
    icon: Icons.swap_horiz,
    color: Colors.indigo,
    screen: Praktikum4Screen(),
  ),
  MenuItem(
    title: 'Praktikum 5 — MQTT',
    subtitle: 'Publish–Subscribe Broker untuk IoT',
    icon: Icons.sensors,
    color: Colors.purple,
    screen: Praktikum5Screen(),
  ),
  MenuItem(
    title: 'Praktikum 6 — WebRTC',
    subtitle: 'Peer-to-Peer Media & Data Channel',
    icon: Icons.video_call,
    color: Colors.redAccent,
    screen: Praktikum6Screen(),
  ),
  MenuItem(
    title: 'Praktikum 7 — gRPC Streaming',
    subtitle: 'Streaming RPC & Protocol Buffers',
    icon: Icons.speed,
    color: Colors.green,
    screen: Praktikum7Screen(),
  ),
  MenuItem(
    title: 'Praktikum 8 — FCM',
    subtitle: 'Push Notification (Foreground & Background)',
    icon: Icons.notifications_active,
    color: Colors.amber,
    screen: Praktikum8Screen(),
  ),
];

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul Realtime Communication'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPracticumScreen(
                        title: item.title,
                        child: item.screen,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: item.color.withValues(alpha: 0.15),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailPracticumScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailPracticumScreen({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: child,
    );
  }
}