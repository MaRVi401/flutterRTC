import 'dart:async';
import 'package:flutter/material.dart';

class Praktikum7Screen extends StatefulWidget {
  const Praktikum7Screen({super.key});

  @override
  State<Praktikum7Screen> createState() => _Praktikum7ScreenState();
}

class _Praktikum7ScreenState extends State<Praktikum7Screen> {
  StreamSubscription? _grpcSubscription;
  final List<String> _streamLogs = [];
  bool _isStreaming = false;
  int _counter = 0;

  // Simulasi gRPC Server Streaming Call: rpc WatchSensor (SensorRequest) returns (stream SensorReading);
  void _startGrpcStream() {
    setState(() {
      _isStreaming = true;
      _streamLogs.insert(0, '[gRPC Client]: Membuka stream WatchSensor()...');
    });

    // Simulasi Stream dari Server gRPC HTTP/2 setiap 1.5 detik
    final grpcStream = Stream.periodic(const Duration(milliseconds: 1500), (i) {
      _counter++;
      return {
        'device_id': 'sensor_01',
        'value': (20.0 + (_counter % 10) * 1.5).toStringAsFixed(1),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    });

    _grpcSubscription = grpcStream.listen((reading) {
      if (mounted) {
        setState(() {
          _streamLogs.insert(
            0,
            '[gRPC Stream Data]: device_id=${reading['device_id']} | value=${reading['value']}°C | ts=${reading['timestamp']}',
          );
        });
      }
    });
  }

  void _stopGrpcStream() {
    _grpcSubscription?.cancel();
    setState(() {
      _isStreaming = false;
      _streamLogs.insert(0, '[gRPC Client]: Stream WatchSensor() ditutup.');
    });
  }

  @override
  void dispose() {
    _grpcSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isStreaming ? null : _startGrpcStream,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start gRPC Stream'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isStreaming ? _stopGrpcStream : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop Stream'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Aliran Data Stream Biner (HTTP/2):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _streamLogs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _streamLogs[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}