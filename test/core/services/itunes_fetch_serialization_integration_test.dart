import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/domain/models/podcast_collection_model.dart';
import 'package:empty_flutter_template/domain/models/podcast_model.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';

void main() {
  group('iTunes-Fetch Serialisierung/Deserialisierung', () {
    test(
      'PodcastCollection, Podcast und PodcastEpisode bleiben 1:1 erhalten',
      () async {
        final original = PodcastCollection(
          podcasts: [
            Podcast(
              wrapperType: 'track',
              collectionId: 123,
              collectionName: 'Test Podcast',
              artistName: 'Test Host',
              primaryGenreName: 'Test Genre',
              artworkUrl600: 'https://img',
              feedUrl: 'https://feed',
              episodes: [
                PodcastEpisode(
                  wrapperType: 'podcastEpisode',
                  trackId: 1,
                  trackName: 'Ep1',
                  artworkUrl600: 'https://img/ep1',
                  description: 'Desc1',
                  episodeUrl: 'https://audio/ep1',
                  trackTimeMillis: 123,
                  episodeFileExtension: 'mp3',
                  releaseDate: DateTime.parse('2024-05-28T12:00:00Z'),
                ),
              ],
            ),
          ],
        );
        final jsonString = jsonEncode(original.toJson());
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = PodcastCollection.fromJson(json);
        expect(restored.podcasts.length, original.podcasts.length);
        final origPodcast = original.podcasts.first;
        final restPodcast = restored.podcasts.first;
        expect(restPodcast.collectionId, origPodcast.collectionId);
        expect(restPodcast.collectionName, origPodcast.collectionName);
        expect(restPodcast.artistName, origPodcast.artistName);
        expect(restPodcast.primaryGenreName, origPodcast.primaryGenreName);
        expect(restPodcast.artworkUrl600, origPodcast.artworkUrl600);
        expect(restPodcast.feedUrl, origPodcast.feedUrl);
        expect(restPodcast.episodes.length, origPodcast.episodes.length);
        final origEp = origPodcast.episodes.first;
        final restEp = restPodcast.episodes.first;
        expect(restEp.trackId, origEp.trackId);
        expect(restEp.trackName, origEp.trackName);
        expect(restEp.artworkUrl600, origEp.artworkUrl600);
        expect(restEp.description, origEp.description);
        expect(restEp.episodeUrl, origEp.episodeUrl);
        expect(restEp.trackTimeMillis, origEp.trackTimeMillis);
        expect(restEp.episodeFileExtension, origEp.episodeFileExtension);
        expect(restEp.releaseDate, origEp.releaseDate);
      },
    );
  });
}
