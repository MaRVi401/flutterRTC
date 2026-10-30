import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String wsUrl = 'ws://10.0.2.2:3000';

class Praktikum4Screen extends StatefulWidget {
  const Praktikum4Screen({super.key});

  @override
  State<Praktikum4Screen> createState() => _Praktikum4ScreenState();
}

class _Praktikum4ScreenState extends State<Praktikum4Screen> {
  WebSocketChannel? _channel;
  final TextEditingController _controller = TextEditingController();
  final List<String> _logs = [];

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    setState(() => _logs.insert(0, '[System]: WS Connected'));

    _channel!.stream.listen((message) {
      if (mounted) setState(() => _logs.insert(0, '[Server]: $message'));
    }, onDone: () {
      if (mounted) setState(() => _logs.insert(0, '[System]: WS Closed'));
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _channel != null) {
      _channel!.sink.add(_controller.text);
      _logs.insert(0, '[Sent]: ${_controller.text}');
      _controller.clear();
      setState(() {});
    }
  }

  void _disconnect() {
    _channel?.sink.close();
  }

  @override
  void dispose() {
    _channel?.sink.close();
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
              ElevatedButton(onPressed: _connect, child: const Text('Connect')),
              ElevatedButton(onPressed: _disconnect, child: const Text('Disconnect')),
            ],
          ),
          TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Pesan WebSocket')),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
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