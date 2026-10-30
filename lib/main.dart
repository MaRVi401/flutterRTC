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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Praktikum1Screen(),
    Praktikum2Screen(),
    Praktikum3Screen(),
    Praktikum4Screen(),
    Praktikum5Screen(),
    Praktikum6Screen(),
    Praktikum7Screen(),
    Praktikum8Screen(),
  ];

  final List<String> _titles = const [
    'P1: REST API',
    'P2: Polling',
    'P3: SSE',
    'P4: WebSocket',
    'P5: MQTT',
    'P6: WebRTC',
    'P7: gRPC Streaming',
    'P8: Push Notification',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.http), label: 'P1: REST'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'P2: Poll'),
          BottomNavigationBarItem(icon: Icon(Icons.stream), label: 'P3: SSE'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'P4: WS'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'P5: MQTT'),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'P6: WebRTC'),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'P7: gRPC'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'P8: FCM'),
        ],
      ),
    );
  }
}