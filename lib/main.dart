import 'package:flutter/material.dart';
import 'package:flutter_voice_wave/audio_wave.dart';
import 'package:flutter_voice_wave/audio_waveforms.dart';
import 'package:flutter_voice_wave/flutter_audio_waveforms.dart';
import 'package:flutter_voice_wave/just_audio_waveform.dart';
import 'package:flutter_voice_wave/waveform_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Wave',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[300],
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Audio Wave'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final libs = [
    LibItemData(
      title: 'waveform_flutter',
      builder: (context) => const WaveformFlutterScreen(),
    ),
    LibItemData(
      title: 'just_audio_waveform',
      builder: (context) => const JustAudioWaveformScreen(),
    ),
    LibItemData(
      title: 'audio_wave',
      builder: (context) => const AudioWaveScreen(),
    ),
    LibItemData(
      title: 'audio_waveforms',
      builder: (context) => const AudioWaveformsScreen(),
    ),
    LibItemData(
      title: 'flutter_audio_waveforms',
      builder: (context) => const FlutterAudioWaveformsScreen(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: libs.length,
        itemBuilder: (context, index) {
          final lib = libs[index];
          return ListTile(
            title: Text(lib.title),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: lib.builder)),
          );
        },
      ),
    );
  }
}

class LibItemData {
  const LibItemData({
    required this.title,
    required this.builder,
  });
  final String title;
  final WidgetBuilder builder;
}
