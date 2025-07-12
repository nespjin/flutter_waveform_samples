import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';

class AudioWaveScreen extends StatefulWidget {
  const AudioWaveScreen({super.key});

  @override
  State<AudioWaveScreen> createState() => _AudioWaveScreenState();
}

class _AudioWaveScreenState extends State<AudioWaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Wave'),
      ),
      body: Column(
        children: [
          const Text('Audio Wave Example'),
          AudioWave(
            bars: [AudioWaveBar(heightFactor: 1)],
          ),
          AudioWave(
            bars: [
              AudioWaveBar(heightFactor: 1, color: Colors.green),
              AudioWaveBar(heightFactor: 0.1, color: Colors.black),
            ],
          ),
          AudioWave(
            height: 32,
            width: 32,
            spacing: 2.5,
            animationLoop: 3,
            bars: [
              AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.8, color: Colors.blue),
              AudioWaveBar(heightFactor: 1, color: Colors.black),
              AudioWaveBar(heightFactor: 0.9),
            ],
          ),
          AudioWave(
            height: 32,
            width: 88,
            spacing: 2.5,
            bars: [
              AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.3, color: Colors.black),
              AudioWaveBar(heightFactor: 0.4),
              AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.8, color: Colors.black),
              AudioWaveBar(heightFactor: 0.9),
              AudioWaveBar(heightFactor: 1, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.3, color: Colors.black),
              AudioWaveBar(heightFactor: 0.4),
              AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.8, color: Colors.black),
              AudioWaveBar(heightFactor: 0.9),
              AudioWaveBar(heightFactor: 1, color: Colors.orange),
            ],
          ),
          AudioWave(
            height: 32,
            width: 88,
            spacing: 2.5,
            alignment: 'top',
            animationLoop: 2,
            beatRate: const Duration(milliseconds: 50),
            bars: [
              AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.3, color: Colors.black),
              AudioWaveBar(heightFactor: 0.4),
              AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.8, color: Colors.black),
              AudioWaveBar(heightFactor: 0.9),
              AudioWaveBar(heightFactor: 1, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.3, color: Colors.black),
              AudioWaveBar(heightFactor: 0.4),
              AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.8, color: Colors.black),
              AudioWaveBar(heightFactor: 0.9),
              AudioWaveBar(heightFactor: 1, color: Colors.orange),
            ],
          ),
          AudioWave(
            height: 32,
            width: 160,
            spacing: 5,
            alignment: 'bottom',
            animationLoop: 2,
            beatRate: const Duration(milliseconds: 50),
            bars: [
              AudioWaveBar(heightFactor: 1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.9, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.8, color: Colors.black),
              AudioWaveBar(heightFactor: 0.7),
              AudioWaveBar(heightFactor: 0.6, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.4, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.3, color: Colors.black),
              AudioWaveBar(heightFactor: 0.2),
              AudioWaveBar(heightFactor: 0.1, color: Colors.orange),
              AudioWaveBar(heightFactor: 1, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.1, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.2, color: Colors.black),
              AudioWaveBar(heightFactor: 0.3),
              AudioWaveBar(heightFactor: 0.4, color: Colors.orange),
              AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
              AudioWaveBar(heightFactor: 0.6, color: Colors.blue),
              AudioWaveBar(heightFactor: 0.7, color: Colors.black),
              AudioWaveBar(heightFactor: 0.8),
              AudioWaveBar(heightFactor: 0.9, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
