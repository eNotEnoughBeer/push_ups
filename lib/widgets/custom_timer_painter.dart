import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.valueInRange0_1,
    required this.backgroundColor,
    required this.color,
  });

  final double valueInRange0_1;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - valueInRange0_1) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return valueInRange0_1 != oldDelegate.valueInRange0_1 ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
