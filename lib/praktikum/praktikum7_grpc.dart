import 'package:flutter/material.dart';

class Praktikum7Screen extends StatelessWidget {
  const Praktikum7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Text('Praktikum 7: gRPC Streaming', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('gRPC menggunakan Protocol Buffers (.proto) dan HTTP/2 Transport.'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Definisi .proto:\n\n'
                'service SensorService {\n'
                '  rpc GetLatest (SensorRequest) returns (SensorReading);\n'
                '  rpc WatchSensor (SensorRequest) returns (stream SensorReading);\n'
                '}',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
          )
        ],
      ),
    );
  }
}