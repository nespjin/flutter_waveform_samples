import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_voice_wave/gen/assets.gen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AudioWaveformsScreen extends StatefulWidget {
  const AudioWaveformsScreen({super.key});

  @override
  State<AudioWaveformsScreen> createState() => _AudioWaveformsScreenState();
}

class _AudioWaveformsScreenState extends State<AudioWaveformsScreen> {
  final PlayerController playerController = PlayerController();
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    audioFilePath =
        path.join((await getTemporaryDirectory()).path, 'audio.mp3');
    final audioFile = File(audioFilePath);
    await audioFile.writeAsBytes(
        (await rootBundle.load(Assets.audio.zhouQhc)).buffer.asUint8List());
    playerController.preparePlayer(path: audioFile.path);

    setState(() => _isReady = true);
  }

  late final String audioFilePath;

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Waveforms'),
      ),
      body: !_isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: playerController.startPlayer,
                  child: const Text('play'),
                ),
                ElevatedButton(
                  onPressed: playerController.pausePlayer,
                  child: const Text('pause'),
                ),
                ElevatedButton(
                  onPressed: playerController.stopPlayer,
                  child: const Text('Stop'),
                ),
                const Text('Builtin waveforms'),
                AudioFileWaveforms(
                  playerController: playerController,
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.blue,
                    liveWaveColor: Colors.red,
                  ),
                  backgroundColor: Colors.grey,
                  size: Size(size.width, 50),
                ),
                const Text('Custome waveforms'),
                CustomeWaveform(
                  playerController: playerController,
                  waveHeight: 50,
                ),
              ],
            ),
    );
  }
}

class CustomeWaveform extends StatefulWidget {
  const CustomeWaveform({
    super.key,
    required this.playerController,
    this.waveHeight = 200,
    this.waveItemWith = 5,
    this.waveItemSpacing = 2,
    this.waveColor = Colors.green,
    this.playedWaveColor = Colors.red,
  });

  final PlayerController playerController;
  final double waveHeight;
  final double waveItemWith;
  final double waveItemSpacing;
  final Color waveColor;
  final Color playedWaveColor;

  @override
  State<CustomeWaveform> createState() => CustomeWaveformState();
}

class CustomeWaveformState extends State<CustomeWaveform> {
  PlayerController get playerController => widget.playerController;
  double get waveHeight => widget.waveHeight;
  double get waveItemWith => widget.waveItemWith;
  double get waveItemSpacing => widget.waveItemSpacing;
  Color get waveColor => widget.waveColor;
  Color get playedWaveColor => widget.playedWaveColor;
  List<double> waveformData = [];

  StreamSubscription<List<double>>? onCurrentExtractedWaveformData;
  StreamSubscription<PlayerState>? onPlayerStateChanged;
  StreamSubscription<int>? onCurrentDurationChanged;
  ScrollController waveformScrollController = ScrollController();

  double musicProgress = 0;
  int maxDuration = -1;
  int playedWaveCount = 0;
  double totalWaveWidth = 0;
  int lastDuration = -1;

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    onCurrentExtractedWaveformData = playerController
        .onCurrentExtractedWaveformData
        .listen(_onWaveformDataUpdate);
    onPlayerStateChanged =
        playerController.onPlayerStateChanged.listen(_onPlayerStateChanged);
    onCurrentDurationChanged = playerController.onCurrentDurationChanged
        .listen(_onCurrentDurationChanged);
  }

  void _onPlayerStateChanged(PlayerState state) async {
    switch (state) {
      case PlayerState.initialized:
        musicProgress = 0;
        maxDuration = -1;
        totalWaveWidth = 0;
      case PlayerState.playing:
      case PlayerState.paused:
      case PlayerState.stopped:
      // musicProgress = 0;
      // maxDuration = -1;
      // totalWaveWidth = 0;
    }
  }

  void _onCurrentDurationChanged(int duration) async {
    if (duration == 0) return;
    if (maxDuration <= 0) {
      maxDuration = await playerController.getDuration(DurationType.max);
    }
    musicProgress = duration / maxDuration;

    final playedWaveCount = musicProgress * waveformData.length;
    this.playedWaveCount = playedWaveCount.round() + 1;
    final playedWaveWidth = calculateWaveformWidth(playedWaveCount + 1);
    final playedPercent =
        (playedWaveWidth / (totalWaveWidth == 0 ? 1 : totalWaveWidth))
            .clamp(0, 1);
    final playedScrollPosition =
        playedPercent * waveformScrollController.position.maxScrollExtent;
    if ((duration - lastDuration).abs() < 500) {
      waveformScrollController.animateTo(
        playedScrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      waveformScrollController.jumpTo(playedScrollPosition);
    }
    // debugPrint('duration: $lastDuration $duration');
    // debugPrint('musicProgress: $musicProgress, $playedScrollPosition');

    lastDuration = duration;
    if (mounted) setState(() => {});
  }

  @override
  void dispose() {
    onPlayerStateChanged?.cancel();
    onCurrentDurationChanged?.cancel();
    onCurrentExtractedWaveformData?.cancel();
    playerController.dispose();
    super.dispose();
  }

  void _onWaveformDataUpdate(List<double> waveformData) {
    this.waveformData
      ..clear()
      ..addAll(waveformData);
    totalWaveWidth = calculateWaveformWidth(waveformData.length);
    if (mounted) setState(() {});
  }

  double calculateWaveformWidth(num count) {
    return count * waveItemWith + (count - 1).clamp(0, count) * waveItemSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final halfWidth = size.width / 2;
    return SizedBox(
      height: waveHeight,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: waveformScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: halfWidth),
                RepaintBoundary(
                  child: AudioWave(
                    height: waveHeight,
                    width: waveItemWith * waveformData.length,
                    spacing: waveItemSpacing,
                    animation: false,
                    bars: waveformData.indexed.map((e) {
                      final (index, data) = e;
                      // debugPrint('wave form data: $data');
                      return AudioWaveBar(
                        heightFactor: (data * 4).clamp(0, 1),
                        color: index < playedWaveCount
                            ? playedWaveColor
                            : waveColor,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: halfWidth),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: waveHeight,
              width: 3,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
