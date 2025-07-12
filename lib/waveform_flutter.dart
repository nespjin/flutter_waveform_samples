import 'package:flutter/material.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class WaveformFlutterScreen extends StatefulWidget {
  const WaveformFlutterScreen({super.key});

  @override
  State<WaveformFlutterScreen> createState() => _WaveformFlutterScreenState();
}

class _WaveformFlutterScreenState extends State<WaveformFlutterScreen> {
    final Stream<Amplitude> _amplitudeStream = createRandomAmplitudeStream();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Waveform Flutter'),
      ),
      body: AnimatedWaveList(stream: _amplitudeStream),
    );
  }
}