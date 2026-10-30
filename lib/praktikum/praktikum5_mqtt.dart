import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Praktikum5Screen extends StatefulWidget {
  const Praktikum5Screen({super.key});

  @override
  State<Praktikum5Screen> createState() => _Praktikum5ScreenState();
}

class _Praktikum5ScreenState extends State<Praktikum5Screen> {
  MqttServerClient? _client;
  final List<String> _logs = [];
  bool _isConnected = false;

  Future<void> _connectMQTT() async {
    final clientID = 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
    _client = MqttServerClient.withPort('broker.hivemq.com', clientID, 1883);

    try {
      await _client!.connect();
      setState(() {
        _isConnected = true;
        _logs.insert(0, 'MQTT Connected');
      });

      _client!.subscribe('kampus/demo/sensor01', MqttQos.atMostOnce);
      _client!.updates?.listen((events) {
        final rec = events[0].payload as MqttPublishMessage;
        final msg = MqttPublishPayload.bytesToStringAsString(rec.payload.message);
        if (mounted) setState(() => _logs.insert(0, 'Topik [${events[0].topic}]: $msg'));
      });
    } catch (e) {
      setState(() => _logs.insert(0, 'Error: $e'));
    }
  }

  void _publishData() {
    if (!_isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode({'temperature': 27.5, 'timestamp': DateTime.now().toIso8601String()}));
    _client!.publishMessage('kampus/demo/sensor01', MqttQos.atMostOnce, builder.payload!);
  }

  @override
  void dispose() {
    _client?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(onPressed: _isConnected ? null : _connectMQTT, child: const Text('Connect MQTT')),
          ElevatedButton(onPressed: _isConnected ? _publishData : null, child: const Text('Publish Sensor Data')),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (ctx, i) => Text(_logs[i]),
            ),
          )
        ],
      ),
    );
  }
}