import 'package:flutter/material.dart';
import '../../application/providers/audio_player_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dropdown für die Abspielgeschwindigkeit im Audio-Player.
class BottomPlayerSpeedDropdown extends ConsumerWidget {
  final double currentSpeed;
  final List<double> speedOptions;
  final ValueChanged<double> onSpeedChanged;

  const BottomPlayerSpeedDropdown({
    super.key,
    required this.currentSpeed,
    required this.speedOptions,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    return StreamBuilder<double>(
      stream: audioBloc.backend.speedStream,
      initialData: currentSpeed,
      builder: (context, snapshot) {
        final speed = snapshot.data ?? currentSpeed;
        // DEBUG: Print jedes Event aus dem Stream
        // ignore: avoid_print
        print('[BottomPlayerSpeedDropdown] speedStream Event: $speed');
        final theme = Theme.of(context);
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Semantics(
            label: 'Abspielgeschwindigkeit wählen',
            child: DropdownButton<double>(
              value: speed,
              items: speedOptions
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          '${s}x ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurface.withAlpha(140),
                            fontSize: 16,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onSpeedChanged(value);
                }
              },
              icon: Icon(Icons.speed,
                  color: theme.colorScheme.onSurface.withAlpha(140), size: 22),
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
        );
      },
    );
  }
}
