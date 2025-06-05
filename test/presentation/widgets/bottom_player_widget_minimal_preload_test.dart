import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/presentation/widgets/bottom_player_widget.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';
import 'package:empty_flutter_template/application/providers/current_episode_provider.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';

void main() {
  testWidgets(
      'Minimaltest: Preload-Overlay und Button im Paused(position=0)-State',
      (tester) async {
    final controller = StreamController<AudioPlayerState>.broadcast();
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerStateProvider.overrideWith((ref) => controller.stream),
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    await tester.pump();
    // Paused-State mit position=0 (Preload-Overlay)
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    // Debug-Ausgaben: Alle Text-Widgets ausgeben
    debugPrint('Alle Text-Widgets:');
    for (final w in tester.allWidgets) {
      if (w is Text) debugPrint('Text: "${w.data}"');
    }
    // Erwartung: Overlay-Text und Button vorhanden, aber disabled
    // Suche robust: Text enthält 'Stream lädt'
    expect(
        find.byWidgetPredicate(
            (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
        findsOneWidget);
    final playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    final playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull,
        reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
    await controller.close();
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle(); // Timer/Marquee cleanup
  });
}
