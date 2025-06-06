import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';

/// Test-Provider für AudioHandler (Mocking im Test)
final audioHandlerProvider = Provider<AudioHandler>((ref) =>
    throw UnimplementedError(
        'audioHandlerProvider muss im Test überschrieben werden'));
