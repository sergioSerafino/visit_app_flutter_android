import 'dart:math' as Math;
import 'package:flutter/material.dart';

class AnimatedStarIcon extends StatelessWidget {
  final Color color;
  final double size;
  final Color outlineColor;
  final double outlineWidth;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;

  const AnimatedStarIcon({
    super.key,
    required this.color,
    required this.size,
    required this.outlineColor,
    required this.outlineWidth,
    required this.shadowColor,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _StarPainter(
        color: color,
        outlineColor: outlineColor,
        outlineWidth: outlineWidth,
        shadowColor: shadowColor,
        shadowBlur: shadowBlur,
        shadowOffset: shadowOffset,
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  final Color outlineColor;
  final double outlineWidth;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;

  _StarPainter({
    required this.color,
    required this.outlineColor,
    required this.outlineWidth,
    required this.shadowColor,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  Path _starPath(double cx, double cy, double r, int points) {
    final path = Path();
    final angle = 2 * Math.pi / points;
    for (int i = 0; i < points; i++) {
      final x = cx + r * Math.cos(i * angle - Math.pi / 2);
      final y = cy + r * Math.sin(i * angle - Math.pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final x2 = cx + r * 0.5 * Math.cos((i + 0.5) * angle - Math.pi / 2);
      final y2 = cy + r * 0.5 * Math.sin((i + 0.5) * angle - Math.pi / 2);
      path.lineTo(x2, y2);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - outlineWidth;
    final star = _starPath(cx, cy, r, 5);

    // Hauptschatten
    if (shadowBlur > 0 && shadowColor.a > 0) {
      final shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(shadowOffset.dx, shadowOffset.dy);
      canvas.drawPath(star, shadowPaint);
      canvas.restore();
    }

    // Akzentuierte Schatten an zwei Ecken
    final accentShadowPaint1 = Paint()
      ..color =
          shadowColor.withAlpha((shadowColor.a * 1.2).clamp(0, 255).toInt())
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur * 1.2)
      ..style = PaintingStyle.fill;
    final accentShadowPaint2 = Paint()
      ..color =
          shadowColor.withAlpha((shadowColor.a * 1.1).clamp(0, 255).toInt())
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur * 1.1)
      ..style = PaintingStyle.fill;
    // Obere Sternspitze
    canvas.save();
    canvas.translate(0, -size.height * 0.13);
    canvas.drawPath(star, accentShadowPaint1);
    canvas.restore();
    // Rechte untere Sternspitze
    canvas.save();
    canvas.translate(size.width * 0.11, size.height * 0.11);
    canvas.drawPath(star, accentShadowPaint2);
    canvas.restore();

    // Sternfüllung
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(star, fillPaint);

    // Outline
    if (outlineWidth > 0 && outlineColor.a > 0) {
      final outlinePaint = Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = outlineWidth;
      canvas.drawPath(star, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
