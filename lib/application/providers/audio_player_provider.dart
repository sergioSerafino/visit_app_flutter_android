// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Audio-Architektur, Provider-Pattern und Teststrategie.
// Lessons Learned: AudioPlayerBloc und Provider-Pattern ermöglichen flexible, testbare Audio-Logik. Siehe auch audio_player_bloc.dart für Details.
// Hinweise: Für produktive Nutzung Backend anpassen, für Tests Mock-Backend verwenden.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_player_bloc.dart';
import '../../core/services/audio_player_sync_service.dart';

// Architektur: Der AudioPlayerBloc erhält das produktive Backend (z.B. JustAudioPlayerBackend).
// Der audioHandler (audio_service) wird für Systemintegration (z.B. AirPlay/Chromecast) später im Backend angebunden.
final audioPlayerBlocProvider = Provider<AudioPlayerBloc>((ref) {
  return AudioPlayerBloc(backend: AudioPlayerSyncService());
});

/// Provider, der den aktuellen State des AudioPlayerBloc als Stream bereitstellt
final audioPlayerStateProvider = StreamProvider<AudioPlayerState>((ref) {
  final bloc = ref.watch(audioPlayerBlocProvider);
  return bloc.stream;
});
