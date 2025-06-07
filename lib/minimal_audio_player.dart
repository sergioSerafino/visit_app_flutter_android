import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Minimaler Audio-Player für einen einzelnen Stream (ohne Bloc, ohne Riverpod)
class MinimalAudioPlayerPage extends StatefulWidget {
  const MinimalAudioPlayerPage({super.key});

  @override
  State<MinimalAudioPlayerPage> createState() => _MinimalAudioPlayerPageState();
}

class _MinimalAudioPlayerPageState extends State<MinimalAudioPlayerPage> {
  final AudioPlayer _player =
      AudioPlayer(); // Buffer-Parameter entfernt, Standard verwenden
  String? _error;
  bool _loading = false;
  bool _isPreloaded = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  static const String url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'; // Beispiel-MP3

  @override
  void initState() {
    super.initState();
    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });
    _player.durationStream.listen((dur) {
      setState(() => _duration = dur);
    });
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  Future<void> _play() async {
    setState(() {
      _loading = true;
      _error = null;
      _isPreloaded = false;
    });
    try {
      await _player.setUrl(url);
      setState(() {
        _isPreloaded = true;
        _loading = false;
      });
      await _player.play();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
        _isPreloaded = false;
      });
    }
  }

  Future<void> _pause() async {
    try {
      await _player.pause();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _stop() async {
    try {
      await _player.stop();
      await _player.seek(Duration.zero);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // UI-State: Nur eine Änderung pro Event, keine Animationen/Flackern
  Widget _buildStatus() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child:
            Text('Fehler: $_error', style: const TextStyle(color: Colors.red)),
      );
    }
    if (_isPreloaded && !_player.playing) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          'Audio vorgeladen – bereit zum Abspielen',
          style: TextStyle(color: Colors.green.shade700),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _player.playing;
    final duration = _duration ?? Duration.zero;
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal Audio Player')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatus(),
            Slider(
              value: _position.inSeconds
                  .clamp(0, duration.inSeconds > 0 ? duration.inSeconds : 1)
                  .toDouble(),
              max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
              onChanged: (v) async {
                await _player.seek(Duration(seconds: v.toInt()));
              },
            ),
            Text(
              '${_format(_position)} / ${_format(duration)}',
              style:
                  const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _play,
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: isPlaying ? _pause : null,
                  child: const Icon(Icons.pause),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stop,
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
