import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:3000';

class Praktikum1Screen extends StatefulWidget {
  const Praktikum1Screen({super.key});

  @override
  State<Praktikum1Screen> createState() => _Praktikum1ScreenState();
}

class _Praktikum1ScreenState extends State<Praktikum1Screen> {
  String _getDataResult = 'Belum ada data';
  String _postDataResult = 'Belum ada tanggapan';
  final TextEditingController _controller = TextEditingController();

  Future<void> _fetchData() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/data'));
      if (res.statusCode == 200) {
        setState(() => _getDataResult = res.body);
      }
    } catch (e) {
      setState(() => _getDataResult = 'Error: $e');
    }
  }

  Future<void> _sendMessage() async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/message'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': _controller.text}),
      );
      if (res.statusCode == 200) {
        setState(() => _postDataResult = res.body);
      }
    } catch (e) {
      setState(() => _postDataResult = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('GET /api/data', style: TextStyle(fontWeight: FontWeight.bold)),
        ElevatedButton(onPressed: _fetchData, child: const Text('Ambil Data')),
        Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(_getDataResult))),
        const Divider(height: 32),
        const Text('POST /api/message', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Pesan')),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _sendMessage, child: const Text('Kirim Pesan')),
        Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(_postDataResult))),
      ],
    );
  }
}