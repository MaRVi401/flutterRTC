import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class Praktikum6Screen extends StatefulWidget {
  const Praktikum6Screen({super.key});

  @override
  State<Praktikum6Screen> createState() => _Praktikum6ScreenState();
}

class _Praktikum6ScreenState extends State<Praktikum6Screen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isCameraOpen = false;
  String _statusMessage = 'Kamera belum diaktifkan';

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _localRenderer.initialize();
  }

  Future<void> _getUserMedia() async {
    // 1. Minta Izin Runtime untuk Kamera dan Mikrofon
    var cameraStatus = await Permission.camera.request();
    var microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      setState(() {
        _statusMessage = 'Izin kamera atau mikrofon ditolak!';
      });
      return;
    }

    if (cameraStatus.isPermanentlyDenied || microphoneStatus.isPermanentlyDenied) {
      setState(() {
        _statusMessage = 'Izin ditolak permanen. Buka pengaturan HP untuk mengizinkan.';
      });
      openAppSettings();
      return;
    }

    // 2. Jika izin diberikan, panggil getUserMedia
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = stream;
      setState(() {
        _isCameraOpen = true;
        _statusMessage = 'Stream kamera berhasil dibuka';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Gagal mengakses media: $e';
      });
    }
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
          ElevatedButton.icon(
            onPressed: _getUserMedia,
            icon: const Icon(Icons.videocam),
            label: const Text('Buka Kamera (getUserMedia)'),
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isCameraOpen
                  ? RTCVideoView(_localRenderer, mirror: true)
                  : const Center(
                      child: Text('Video Feed Belum Aktif'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}