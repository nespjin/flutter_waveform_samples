import 'package:flutter/material.dart';

class FlutterAudioWaveformsScreen extends StatefulWidget {
  const FlutterAudioWaveformsScreen({super.key});

  @override
  State<FlutterAudioWaveformsScreen> createState() => _FlutterAudioWaveformsScreenState();
}

class _FlutterAudioWaveformsScreenState extends State<FlutterAudioWaveformsScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Wave'),
      ),
      body: const SizedBox(),
    );
  }
}