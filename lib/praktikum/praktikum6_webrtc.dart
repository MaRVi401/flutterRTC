import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Praktikum6Screen extends StatefulWidget {
  const Praktikum6Screen({super.key});

  @override
  State<Praktikum6Screen> createState() => _Praktikum6ScreenState();
}

class _Praktikum6ScreenState extends State<Praktikum6Screen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _localRenderer.initialize();
  }

  Future<void> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {'audio': true, 'video': true};
    final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
    setState(() {});
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(onPressed: _getUserMedia, child: const Text('Buka Kamera (getUserMedia)')),
          const SizedBox(height: 12),
          Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
        ],
      ),
    );
  }
}