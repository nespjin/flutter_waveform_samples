import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_voice_wave/gen/assets.gen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class JustAudioWaveformScreen extends StatefulWidget {
  const JustAudioWaveformScreen({super.key});

  @override
  State<JustAudioWaveformScreen> createState() =>
      _JustAudioWaveformScreenState();
}

class _JustAudioWaveformScreenState extends State<JustAudioWaveformScreen> {
  final player = AudioPlayer();

  late final StreamController<WaveformProgress> progressController =
      StreamController.broadcast();
  Stream<WaveformProgress> get progressStream => progressController.stream;

  StreamSubscription? _progressSubscription;

  @override
  void initState() {
    super.initState();
    player.setAsset(Assets.audio.zhouQhc).then((value) => player.play());
    _initWaveform();
  }

  Future<void> _initWaveform() async {
    try {
      final audioInFile =
          File(join((await getTemporaryDirectory()).path, 'audio.mp3'));
      final waveOutputFile =
          File(join((await getTemporaryDirectory()).path, 'audio.wave'));

      await audioInFile.writeAsBytes(
          (await rootBundle.load(Assets.audio.zhouQhc)).buffer.asUint8List());

      _progressSubscription = JustWaveform.extract(
        audioInFile: audioInFile,
        waveOutFile: waveOutputFile,
      ).listen(
        progressController.add,
        onError: progressController.addError,
      );
    } catch (e) {
      debugPrint('error occures $e');
      progressController.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Audio Waveform'),
      ),
      body: StreamBuilder<WaveformProgress>(
        stream: progressStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            );
          }
          final progress = snapshot.data?.progress ?? 0.0;
          final waveform = snapshot.data?.waveform;
          if (waveform == null) {
            return Center(
              child: Text(
                '${(100 * progress).toInt()}%',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          debugPrint("waveform is  ${waveform.toString()}");
          return Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 300,
              child: AudioWaveformWidget(
                waveform: waveform,
                start: Duration.zero,
                duration: waveform.duration,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    progressController.close();
    player.dispose();
  }
}

class AudioWaveformWidget extends StatefulWidget {
  const AudioWaveformWidget({
    super.key,
    required this.waveform,
    required this.start,
    required this.duration,
    this.waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  });

  final Color waveColor;
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveformWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveColor: widget.waveColor,
          waveform: widget.waveform,
          start: widget.start,
          duration: widget.duration,
          scale: widget.scale,
          strokeWidth: widget.strokeWidth,
          pixelsPerStep: widget.pixelsPerStep,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Paint wavePaint;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    Color waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : wavePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    double width = size.width;
    double height = size.height;

    debugPrint('width: $width, height: $height');
    final waveformPixelsPerWindow = waveform.positionToPixel(duration).toInt();
    debugPrint('waveformPixelsPerWindow: $waveformPixelsPerWindow');
    final waveformPixelsPerDevicePixel = waveformPixelsPerWindow / width;
    final waveformPixelsPerStep = waveformPixelsPerDevicePixel * pixelsPerStep;
    final sampleOffset = waveform.positionToPixel(start);
    final sampleStart = -sampleOffset % waveformPixelsPerStep;
    for (var i = sampleStart.toDouble();
        i <= waveformPixelsPerWindow + 1.0;
        i += waveformPixelsPerStep) {
      final sampleIdx = (sampleOffset + i).toInt();
      final x = i / waveformPixelsPerDevicePixel;
      final minY = normalise(waveform.getPixelMin(sampleIdx), height);
      final maxY = normalise(waveform.getPixelMax(sampleIdx), height);
      canvas.drawLine(
        Offset(x + strokeWidth / 2, max(strokeWidth * 0.75, minY)),
        Offset(x + strokeWidth / 2, min(height - strokeWidth * 0.75, maxY)),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return false;
  }

  double normalise(int s, double height) {
    if (waveform.flags == 0) {
      final y = 32768 + (scale * s).clamp(-32768.0, 32767.0).toDouble();
      return height - 1 - y * height / 65536;
    } else {
      final y = 128 + (scale * s).clamp(-128.0, 127.0).toDouble();
      return height - 1 - y * height / 256;
    }
  }
}
