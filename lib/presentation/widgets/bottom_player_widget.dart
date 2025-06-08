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
library;

// lib/presentation/widgets/bottom_player_widget.dart
// MIGRATION-HINWEIS: Diese Datei wurde aus storage_hold/lib/presentation/widgets/bottom_player_widget.dart übernommen und refaktoriert.
// Tooltips, Button-Layout und zentrale Play/Pause-Logik wurden konsolidiert. Siehe Migrationsmatrix und Review-Checkliste.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/collection_provider.dart';
import '../../core/services/audio_player_bloc.dart';
import 'bottom_player_progress_bar.dart';
import 'bottom_player_transport_buttons.dart';
import 'bottom_player_title_collection.dart';
import 'bottom_player_overlay.dart';
import 'bottom_player_error_widget.dart';

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
    // Fallback: Nach Reset (Idle-State) bleibt der Play/Pause-Button aktiv,
    // solange eine gültige Episode im Provider liegt. Sollte der Provider
    // versehentlich auf null gesetzt werden, kann die UI (z.B. nach Reset)
    // die letzte Episode wieder in den Provider schreiben.
    final audioStateAsync = ref.watch(audioPlayerStateProvider);
    // ---
    // 1. ErrorState: Widget-Baum ersetzen
    final errorWidget = audioStateAsync.whenOrNull(
      data: (audioState) =>
          (audioState is ErrorState && audioState.message.isNotEmpty)
              ? BottomPlayerErrorWidget(
                  theme: theme,
                  message: audioState.message,
                  onClose: onClose,
                )
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

    // ---
    // 2a. Player-Content als Komposition von Sub-Widgets
    Widget playerContent = SafeArea(
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
              // Titel und Collection
              Consumer(
                builder: (context, ref, child) {
                  final collectionId = ref.watch(collectionIdProvider);
                  final podcastCollectionAsync =
                      ref.watch(podcastCollectionProvider(collectionId));
                  String collectionName = '';
                  podcastCollectionAsync.whenOrNull(
                    data: (apiResponse) => apiResponse.whenOrNull(
                      success: (collection) {
                        collectionName = collection.podcasts.isNotEmpty
                            ? collection.podcasts.first.collectionName
                            : '';
                      },
                    ),
                  );
                  return BottomPlayerTitleCollection(
                    title: currentEpisode.trackName,
                    collectionName: collectionName,
                    artworkUrl: currentEpisode.artworkUrl600,
                    currentSpeed: currentSpeed,
                    speedOptions: speedOptions,
                    onSpeedChanged: (v) => audioBloc.add(SetSpeed(v)),
                  );
                },
              ),
              // const SizedBox(height: 8),
            ],
            // Fortschrittsbalken
            BottomPlayerProgressBar(
              position: position,
              duration: duration,
              hasValidDuration: hasValidDuration,
              onSeek: (d) => audioBloc.add(Seek(d)),
            ),
            // Transport-Buttons und Lautstärke
            BottomPlayerTransportButtons(
              isPlaying: isPlaying,
              isPlayPauseButtonEnabled: isPlayPauseButtonEnabled,
              position: position,
              duration: duration,
              onPlayPause: () => audioBloc.add(TogglePlayPause()),
              onReset: () => audioBloc.add(Stop()),
              onRewind: () {
                final newPos = position - const Duration(seconds: 10);
                audioBloc
                    .add(Seek(newPos > Duration.zero ? newPos : Duration.zero));
              },
              onForward: () {
                final newPos = position + const Duration(seconds: 10);
                audioBloc.add(Seek(newPos < duration ? newPos : duration));
              },
              volumeButton:
                  _VolumeOverlayButton(audioBloc: audioBloc, theme: theme),
            ),
            // const SizedBox(height: 8),
          ],
        ),
      ),
    );
    // ---
    // 3. Overlay nur als Schicht darüber
    if (showPreloadOverlay || showLoadingOverlay) {
      return BottomPlayerOverlay(
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
  double _currentVolume = 0.5; // Standardwert jetzt 50 %
  double? _pendingVolume; // Merkt sich den Zielwert nach Drag
  OverlayEntry? _overlayEntry;
  Timer? _autoCloseTimer;
  Timer? _debounceTimer; // Für Debounce der Lautstärke
  bool _isDragging = false;

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
              left: buttonOffset.dx + buttonSize.width / 2 - 32, // Breiter
              top: buttonOffset.dy - 170, // Höher
              child: MouseRegion(
                onEnter: (_) => _cancelAutoClose(),
                onExit: (_) => _startAutoClose(),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: widget.theme.colorScheme.surface,
                  child: Container(
                    padding: EdgeInsets.zero,
                    width: 72,
                    height: 240,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: StreamBuilder(
                        stream: widget.audioBloc.stream,
                        initialData: widget.audioBloc.state,
                        builder: (context, snapshot) {
                          double stateVolume = 0.5;
                          final state = snapshot.data;
                          final isActive = state is Playing || state is Paused;
                          if (state is Playing) {
                            stateVolume = state.volume;
                          } else if (state is Paused) {
                            stateVolume = state.volume;
                          } else if (state is Idle) {
                            stateVolume = state.volume;
                          } else if (state is Loading) {
                            stateVolume = state.volume;
                          }
                          // Nur bei aktivem Stream synchronisieren
                          if (isActive &&
                              !_isDragging &&
                              _pendingVolume == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() => _currentVolume = stateVolume);
                              }
                            });
                          }
                          // NEU: _pendingVolume-Logik für Synchronität nach Drag
                          if (_pendingVolume != null &&
                              (stateVolume - _pendingVolume!).abs() < 0.001) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _isDragging = false;
                                  _pendingVolume = null;
                                });
                              }
                            });
                          }
                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 16),
                              trackHeight: 10,
                            ),
                            child: Slider(
                              value: (!isActive)
                                  ? _currentVolume
                                  : (_isDragging
                                      ? _currentVolume
                                      : stateVolume),
                              onChanged: (v) {
                                setState(() {
                                  _currentVolume = v;
                                  _isDragging = true;
                                });
                                _debounceSetVolume(v);
                                _cancelAutoClose();
                                _startAutoClose();
                              },
                              onChangeEnd: (v) {
                                _pendingVolume = v;
                                if (!isActive) {
                                  setState(() {
                                    _isDragging = false;
                                    _pendingVolume = null;
                                    _currentVolume = v;
                                  });
                                }
                                // Bei aktivem Stream bleibt die Pending-Logik wie gehabt
                                else {
                                  // ...bestehende Pending-Logik...
                                }
                              },
                            ),
                          );
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

  void _debounceSetVolume(double v) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      widget.audioBloc.add(SetVolume(v));
    });
  }

  void _removeOverlay({bool fromDispose = false}) {
    _autoCloseTimer?.cancel();
    _debounceTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_showSlider) {
      if (fromDispose || !mounted) {
        _showSlider = false;
      } else {
        setState(() {
          _showSlider = false;
        });
      }
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
    _removeOverlay(fromDispose: true);
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
