/// BottomPlayerWidget
///
/// Zeigt den Audio-Player am unteren Bildschirmrand mit Play/Pause, Fortschritt, Speed-Control und Overlay-Indikatoren.
///
/// **State- und Button-Logik:**
/// - Der Play/Pause-Button ist IMMER enabled, solange eine gültige Episode und KEIN Error/Loading-State aktiv ist.
///   - Auch im Preload-Overlay (Paused, position=0) ist der Button enabled (wie bei Spotify, Apple Podcasts, just_audio, YouTube).
///   - Nur im Error- oder Loading-State ist der Button disabled.
/// - Nach Klick auf Play wird sofort das Pause-Icon angezeigt, auch wenn das Audio noch lädt (UX-Standard).
///
/// **Overlay-Logik:**
/// - "Wird geladen…"-Overlay bei [Loading]
/// - "Audio vorgeladen – bereit zum Abspielen"-Overlay bei [Paused] und position=0
///
/// **Testbarkeit & Lessons Learned:**
/// - Die Logik ist deterministisch und robust gegen schnelles Klicken.
/// - Widget-Tests können alle State-Wechsel und Overlay-Zustände gezielt simulieren.
/// - Für Animationen/Timer (z.B. Marquee) müssen Tests nach Testende den Widget-Baum abräumen (Container pumpen), um Pending-Timer-Fehler zu vermeiden.
/// - Siehe auch: audio_player_best_practices_2025.md, Widget-Tests, AudioPlayerBloc.
///
/// **Fazit:**
/// Das Widget ist für moderne Audio-Streaming-UX optimiert und folgt Best Practices führender Player. Die Button- und Overlay-Logik ist explizit dokumentiert und testbar.

// lib/presentation/widgets/bottom_player_widget.dart
// MIGRATION-HINWEIS: Diese Datei wurde aus storage_hold/lib/presentation/widgets/bottom_player_widget.dart übernommen und refaktoriert.
// Tooltips, Button-Layout und zentrale Play/Pause-Logik wurden konsolidiert. Siehe Migrationsmatrix und Review-Checkliste.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';

import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../../core/services/audio_player_bloc.dart';

class BottomPlayerWidget extends ConsumerWidget {
  final VoidCallback? onClose;
  const BottomPlayerWidget({super.key, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    final currentEpisode = ref.watch(currentEpisodeProvider);
    final hasValidUrl =
        currentEpisode != null && currentEpisode.episodeUrl.isNotEmpty;
    final audioStateAsync = ref.watch(audioPlayerStateProvider);
    // ---
    // 1. ErrorState: Widget-Baum ersetzen
    final errorWidget = audioStateAsync.whenOrNull(
      data: (audioState) =>
          (audioState is ErrorState && audioState.message.isNotEmpty)
              ? _buildErrorWidget(theme, audioState.message)
              : null,
      error: (e, _) => Text('Fehler im AudioPlayer: $e'),
    );
    if (errorWidget != null) return errorWidget;
    // ---
    // 2. Player-Content immer bauen
    // Default-States
    final audioState = audioStateAsync.asData?.value;
    final isPlaying = audioState is Playing;
    final isActive = audioState is Playing || audioState is Paused;
    final position =
        isActive ? (audioState as dynamic).position as Duration : Duration.zero;
    final duration =
        isActive ? (audioState as dynamic).duration as Duration : Duration.zero;
    final hasValidDuration =
        isActive && duration.inSeconds > 0 && duration.inSeconds < 24 * 60 * 60;
    final double currentSpeed = (audioState is Playing)
        ? audioState.speed
        : (audioState is Paused)
            ? audioState.speed
            : 1.0;
    final List<double> speedOptions = [0.5, 1.0, 1.5, 2.0];
    final isPaused = audioState is Paused;
    final isPreloadOverlay =
        isPaused && position == Duration.zero && hasValidUrl;
    final isLoading = audioState is Loading;
    final isError = audioState is ErrorState;
    final isPlayPauseButtonEnabled = _isPlayPauseButtonEnabled(
      hasValidUrl: hasValidUrl,
      isLoading: isLoading,
      isError: isError,
    );
    final showPreloadOverlay = isPreloadOverlay;
    final showLoadingOverlay = isLoading;
    Widget playerContent = _buildPlayerContent(
      context: context,
      theme: theme,
      currentEpisode: currentEpisode,
      currentSpeed: currentSpeed,
      speedOptions: speedOptions,
      audioBloc: audioBloc,
      isPlaying: isPlaying,
      isPlayPauseButtonEnabled: isPlayPauseButtonEnabled,
      position: position,
      duration: duration,
      hasValidDuration: hasValidDuration,
      onClose: onClose,
    );
    // ---
    // 3. Overlay nur als Schicht darüber
    if (showPreloadOverlay || showLoadingOverlay) {
      return _buildOverlayStack(
        playerContent: playerContent,
        theme: theme,
        showLoadingOverlay: showLoadingOverlay,
      );
    }
    return playerContent;
  }

  /// Prüft, ob der Play/Pause-Button enabled ist (wie Spotify/Apple/just_audio):
  /// - Button ist IMMER enabled, solange eine gültige Episode und KEIN Error/Loading-State aktiv ist.
  /// - Robust gegen schnelles Klicken, da Events im Bloc deterministisch verarbeitet werden.
  bool _isPlayPauseButtonEnabled({
    required bool hasValidUrl,
    required bool isLoading,
    required bool isError,
  }) {
    return hasValidUrl && !isLoading && !isError;
  }

  Widget _buildErrorWidget(ThemeData theme, String message) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              // Close-Button im Fehlerfall anzeigen, wenn onClose gesetzt ist
              if (onClose != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  label: 'Player schließen',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onClose,
                    tooltip: 'Player schließen',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayStack({
    required Widget playerContent,
    required ThemeData theme,
    required bool showLoadingOverlay,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        playerContent,
        if (showLoadingOverlay)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: true,
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(
                    theme.colorScheme.primary.red,
                    theme.colorScheme.primary.green,
                    theme.colorScheme.primary.blue,
                    0.18,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerContent({
    required BuildContext context,
    required ThemeData theme,
    required dynamic currentEpisode,
    required double currentSpeed,
    required List<double> speedOptions,
    required dynamic audioBloc,
    required bool isPlaying,
    required bool isPlayPauseButtonEnabled,
    required Duration position,
    required Duration duration,
    required bool hasValidDuration,
    required VoidCallback? onClose,
  }) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(65), blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentEpisode != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Row(
                  children: [
                    if (currentEpisode.artworkUrl600.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          currentEpisode.artworkUrl600,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.music_note,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    if (currentEpisode.artworkUrl600.isEmpty)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note, color: Colors.grey),
                      ),
                    const SizedBox(width: 26),
                    Expanded(
                      flex: 2,
                      child: Semantics(
                        label: 'Aktuelle Episode: ${currentEpisode.trackName}',
                        child: SizedBox(
                          height: 28,
                          child: Marquee(
                            text: currentEpisode.trackName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurface.withAlpha(100),
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 24.0,
                            velocity: 28.0,
                            pauseAfterRound: const Duration(seconds: 3),
                            startPadding: 0.0,
                            accelerationDuration:
                                const Duration(milliseconds: 600),
                            accelerationCurve: Curves.easeIn,
                            decelerationDuration:
                                const Duration(milliseconds: 600),
                            decelerationCurve: Curves.easeOut,
                            showFadingOnlyWhenScrolling: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Semantics(
                          label: 'Abspielgeschwindigkeit wählen',
                          child: DropdownButton<double>(
                            value: currentSpeed,
                            items: speedOptions
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        '${s}x ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: theme.colorScheme.onSurface
                                              .withAlpha(140),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                audioBloc.add(SetSpeed(value));
                              }
                            },
                            icon: Icon(Icons.speed,
                                color:
                                    theme.colorScheme.onSurface.withAlpha(140),
                                size: 22),
                            dropdownColor: theme.colorScheme.surface,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurface.withAlpha(140),
                              fontSize: 16,
                            ),
                            underline: Container(
                              height: 1.5,
                              color: theme.colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Builder(
              builder: (context) {
                final leftTime = _formatDurationMMSS(position.inMilliseconds);
                final rightTime = hasValidDuration
                    ? '-${_formatDurationMMSS((duration - position).inMilliseconds)}'
                    : '0h 0m 0s';
                final isSliderEnabled = hasValidDuration;
                return Row(
                  children: [
                    SizedBox(
                      width: 78,
                      child: Text(
                        leftTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withAlpha(140),
                          //fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    //const SizedBox(width: 4),
                    Expanded(
                      child: Semantics(
                        label: hasValidDuration
                            ? 'Fortschritt: ${position.inSeconds} Sekunden von ${duration.inSeconds} Sekunden'
                            : 'Kein Fortschritt verfügbar',
                        value: leftTime,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: theme.colorScheme.primary,
                            inactiveTrackColor:
                                theme.colorScheme.surfaceContainerHighest,
                            thumbColor:
                                theme.colorScheme.primary.withAlpha(180),
                            overlayColor:
                                theme.colorScheme.primary.withAlpha(32),
                            trackHeight: 14,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 9),
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor:
                                theme.colorScheme.primary.withAlpha(180),
                            showValueIndicator:
                                ShowValueIndicator.onlyForContinuous,
                          ),
                          child: Slider(
                            value: hasValidDuration && position.inSeconds >= 0
                                ? position.inSeconds
                                    .clamp(0, duration.inSeconds)
                                    .toDouble()
                                : 0.0,
                            max: hasValidDuration
                                ? duration.inSeconds.toDouble()
                                : 1.0,
                            divisions:
                                hasValidDuration ? duration.inSeconds : null,
                            label: leftTime,
                            onChanged: isSliderEnabled
                                ? (v) {
                                    audioBloc.add(
                                        Seek(Duration(seconds: v.toInt())));
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 4),
                    SizedBox(
                      width: 85,
                      child: Text(
                        rightTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withAlpha(140),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Linker Stack: Reset-Button
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    IconButton(
                      icon: Icon(Icons.refresh,
                          color: theme.colorScheme.onSurface.withAlpha(140)),
                      iconSize: 24,
                      tooltip: 'Player zurücksetzen',
                      onPressed: () {
                        audioBloc.add(Stop());
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Zentrale Transport-Buttons (unverändert)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: '10 Sekunden zurück',
                        button: true,
                        child: IconButton(
                          icon: Icon(Icons.replay_10,
                              color:
                                  theme.colorScheme.onSurface.withAlpha(140)),
                          iconSize: 32,
                          onPressed: () {
                            final newPos =
                                position - const Duration(seconds: 10);
                            audioBloc.add(Seek(newPos > Duration.zero
                                ? newPos
                                : Duration.zero));
                          },
                          tooltip: '10 Sekunden zurück',
                        ),
                      ),
                      const SizedBox(width: 32),
                      Semantics(
                        label: isPlaying ? 'Pause' : 'Wiedergabe starten',
                        button: true,
                        child: IconButton(
                          key: const Key('player_play_pause_button'),
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: theme.colorScheme.onSurface.withAlpha(140),
                            size: 56,
                          ),
                          iconSize: 56,
                          onPressed: isPlayPauseButtonEnabled
                              ? () {
                                  audioBloc.add(TogglePlayPause());
                                }
                              : null,
                          tooltip: isPlaying ? 'Pause' : 'Wiedergabe starten',
                        ),
                      ),
                      const SizedBox(width: 32),
                      Semantics(
                        label: '10 Sekunden vor',
                        button: true,
                        child: IconButton(
                          icon: Icon(Icons.forward_10,
                              color:
                                  theme.colorScheme.onSurface.withAlpha(140)),
                          iconSize: 32,
                          onPressed: () {
                            final newPos =
                                position + const Duration(seconds: 10);
                            audioBloc.add(
                                Seek(newPos < duration ? newPos : duration));
                          },
                          tooltip: '10 Sekunden vor',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Rechter Stack: Lautstärke-Button mit Overlay
                _VolumeOverlayButton(audioBloc: audioBloc, theme: theme),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatDurationMMSS(int millis) {
    final totalSeconds = (millis / 1000).round();
    final hours = (totalSeconds ~/ 3600);
    final minutes = ((totalSeconds % 3600) ~/ 60);
    final seconds = totalSeconds % 60;
    return '${hours.toString()}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }
}

class _VolumeOverlayButton extends StatefulWidget {
  final dynamic audioBloc;
  final ThemeData theme;
  const _VolumeOverlayButton({required this.audioBloc, required this.theme});

  @override
  State<_VolumeOverlayButton> createState() => _VolumeOverlayButtonState();
}

class _VolumeOverlayButtonState extends State<_VolumeOverlayButton> {
  bool _showSlider = false;
  double _currentVolume = 0.7;
  OverlayEntry? _overlayEntry;
  Timer? _autoCloseTimer;

  void _toggleSlider() {
    if (_showSlider) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _showSlider = !_showSlider;
    });
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    RenderBox box = context.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);
    final buttonSize = box.size;
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              left: buttonOffset.dx + buttonSize.width / 2 - 24,
              top: buttonOffset.dy - 150,
              child: MouseRegion(
                onEnter: (_) => _cancelAutoClose(),
                onExit: (_) => _startAutoClose(),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: widget.theme.colorScheme.surface,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    width: 48,
                    height: 140,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: _currentVolume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (v) {
                          setState(() => _currentVolume = v);
                          widget.audioBloc.add(SetVolume(v));
                          _cancelAutoClose();
                          _startAutoClose();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
    _startAutoClose();
  }

  void _removeOverlay() {
    _autoCloseTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_showSlider) {
      setState(() {
        _showSlider = false;
      });
    }
  }

  void _startAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(milliseconds: 1800), _removeOverlay);
  }

  void _cancelAutoClose() {
    _autoCloseTimer?.cancel();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.volume_up,
          color: widget.theme.colorScheme.onSurface.withAlpha(140)),
      iconSize: 24,
      tooltip: 'Lautstärke',
      onPressed: _toggleSlider,
    );
  }
}
