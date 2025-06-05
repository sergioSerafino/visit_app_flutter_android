// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Audio-Architektur, Provider-Pattern und Teststrategie.
// Lessons Learned: AudioPlayerBloc und Provider-Pattern ermöglichen flexible, testbare Audio-Logik. Siehe auch audio_player_bloc.dart für Details.
// Hinweise: Für produktive Nutzung Backend anpassen, für Tests Mock-Backend verwenden.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_player_bloc.dart';

final audioPlayerBlocProvider = Provider<AudioPlayerBloc>((ref) {
  // Für Test: audioplayers-Backend aktivieren
  return AudioPlayerBloc(backend: AudioPlayersBackend());
});

/// Provider, der den aktuellen State des AudioPlayerBloc als Stream bereitstellt
final audioPlayerStateProvider = StreamProvider<AudioPlayerState>((ref) {
  final bloc = ref.watch(audioPlayerBlocProvider);
  return bloc.stream;
});
