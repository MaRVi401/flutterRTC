import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:3000';

class Praktikum2Screen extends StatefulWidget {
  const Praktikum2Screen({super.key});

  @override
  State<Praktikum2Screen> createState() => _Praktikum2ScreenState();
}

class _Praktikum2ScreenState extends State<Praktikum2Screen> {
  Timer? _timer;
  String _pollData = 'Polling dihentikan';
  bool _isPolling = false;

  void _togglePolling() {
    if (_isPolling) {
      _timer?.cancel();
      setState(() {
        _isPolling = false;
        _pollData = 'Polling dihentikan';
      });
    } else {
      setState(() => _isPolling = true);
      _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
        try {
          final res = await http.get(Uri.parse('$baseUrl/api/data'));
          if (mounted && res.statusCode == 200) {
            setState(() => _pollData = res.body);
          }
        } catch (e) {
          if (mounted) setState(() => _pollData = 'Error: $e');
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _togglePolling,
            child: Text(_isPolling ? 'Stop Polling' : 'Start Polling (2 detik)'),
          ),
          const SizedBox(height: 16),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_pollData))),
        ],
      ),
    );
  }
}