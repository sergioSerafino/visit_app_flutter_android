import 'package:flutter/material.dart';
import '../../application/providers/audio_player_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_player_bloc.dart';

/// Dropdown für die Abspielgeschwindigkeit im Audio-Player.
class BottomPlayerSpeedDropdown extends ConsumerStatefulWidget {
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
  ConsumerState<BottomPlayerSpeedDropdown> createState() =>
      _BottomPlayerSpeedDropdownState();
}

class _BottomPlayerSpeedDropdownState
    extends ConsumerState<BottomPlayerSpeedDropdown> {
  late double _currentSpeed;
  bool _isDragging = false;
  double? _pendingSpeed;

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.currentSpeed;
  }

  void _setSpeed(double speed) {
    setState(() {
      _currentSpeed = speed;
      _isDragging = true;
      _pendingSpeed = speed;
    });
    widget.onSpeedChanged(speed);
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    return StreamBuilder<AudioPlayerState>(
      stream: audioBloc.stream,
      initialData: audioBloc.state,
      builder: (context, snapshot) {
        final state = snapshot.data;
        double stateSpeed = widget.currentSpeed;
        final isActive = state is Playing || state is Paused;
        if (state is Playing) {
          stateSpeed = state.speed;
        } else if (state is Paused) {
          stateSpeed = state.speed;
        }
        // Synchronisiere nur bei aktivem Stream und wenn kein Drag läuft
        if (isActive && !_isDragging && _pendingSpeed == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentSpeed = stateSpeed);
          });
        }
        // Nach Drag: Wenn der State-Speed dem Pending-Speed entspricht, Drag zurücksetzen
        if (_pendingSpeed != null &&
            (stateSpeed - _pendingSpeed!).abs() < 0.001) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isDragging = false;
                _pendingSpeed = null;
              });
            }
          });
        }
        final theme = Theme.of(context);
        // Statt ConstrainedBox: flexiblere Breite, um Overflows zu vermeiden
        return SizedBox(
          width:
              double.infinity, // Maximale Breite, damit Dropdown nie overflowed
          child: Semantics(
            label: 'Abspielgeschwindigkeit wählen',
            child: DropdownButton<double>(
              value: (!isActive)
                  ? _currentSpeed
                  : (_isDragging ? _currentSpeed : stateSpeed),
              items: widget.speedOptions
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
                  _setSpeed(value);
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
