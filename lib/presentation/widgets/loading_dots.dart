// lib/presentation/widgets/loading_dots.dart

import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  final Duration duration;
  final Color color;
  const LoadingDots({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.color = Colors.white,
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * 6,
    )..repeat();

    _animations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.0, end: -6.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor =
        widget.color == Colors.white ? theme.colorScheme.primary : widget.color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _animations.map((anim) => _dot(anim, dotColor)).toList(),
    );
  }

  Widget _dot(Animation<double> anim, Color color) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return Transform.translate(offset: Offset(0, anim.value), child: child);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          '.',
          style: TextStyle(
            fontSize: 36,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
