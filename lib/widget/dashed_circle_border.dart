import 'dart:math';

import 'package:flutter/material.dart';

class DashedCircleBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  const DashedCircleBorder({
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashWidth = 0.3,
    this.dashGap = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCircleBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: child,
    );
  }
}

class _DashedCircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedCircleBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double i = 0.00;
    while (i < pi * 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i,
        dashWidth,
        false,
        paint,
      );
      i = i + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
