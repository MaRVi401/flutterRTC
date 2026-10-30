import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:3000';

class Praktikum3Screen extends StatefulWidget {
  const Praktikum3Screen({super.key});

  @override
  State<Praktikum3Screen> createState() => _Praktikum3ScreenState();
}

class _Praktikum3ScreenState extends State<Praktikum3Screen> {
  http.Client? _client;
  final List<String> _events = [];
  bool _isConnected = false;

  void _connectSSE() async {
    _client = http.Client();
    setState(() {
      _isConnected = true;
      _events.add('Connecting to SSE...');
    });

    try {
      final req = http.Request('GET', Uri.parse('$baseUrl/api/events'));
      req.headers['Accept'] = 'text/event-stream';
      final res = await _client!.send(req);

      res.stream.transform(utf8.decoder).listen((data) {
        if (mounted) {
          setState(() {
            _events.insert(0, data.trim());
          });
        }
      });
    } catch (e) {
      if (mounted) setState(() => _events.insert(0, 'SSE Error: $e'));
    }
  }

  void _disconnectSSE() {
    _client?.close();
    setState(() {
      _isConnected = false;
      _events.insert(0, 'Koneksi SSE ditutup');
    });
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _isConnected ? null : _connectSSE, child: const Text('Connect SSE')),
              ElevatedButton(onPressed: _isConnected ? _disconnectSSE : null, child: const Text('Disconnect')),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (ctx, i) => Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(_events[i]))),
            ),
          ),
        ],
      ),
    );
  }
}