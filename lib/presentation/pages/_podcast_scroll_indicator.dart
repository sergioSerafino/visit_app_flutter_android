import 'package:flutter/material.dart';

class PodcastScrollIndicator extends StatefulWidget {
  final ScrollController scrollController;
  const PodcastScrollIndicator({required this.scrollController, super.key});

  @override
  State<PodcastScrollIndicator> createState() => _PodcastScrollIndicatorState();
}

class _PodcastScrollIndicatorState extends State<PodcastScrollIndicator> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateProgress);
    _updateProgress();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    final controller = widget.scrollController;
    if (!controller.hasClients || controller.position.maxScrollExtent == 0) {
      setState(() => _progress = 0.0);
      return;
    }
    final progress = (controller.offset / controller.position.maxScrollExtent)
        .clamp(0.0, 1.0);
    setState(() => _progress = progress);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Transform.rotate(
        angle: 3.1416, // 180 Grad in Bogenmaß
        child: Container(
          height: 18, // etwas breiter
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30), // noch dezenterer Hintergrund
            borderRadius: BorderRadius.circular(3),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withAlpha(50), // weniger präsent
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
