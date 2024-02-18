import 'dart:math';
import 'package:flutter/material.dart';

class RoundTablePainter extends CustomPainter {
  final int chairsCount;
  final double widgetSize;
  final Color color;

  RoundTablePainter(
      {required this.chairsCount,
      required this.widgetSize,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Table
    final tableRadius = widgetSize / 2;
    final tableCenter = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(tableCenter, tableRadius, paint);

    // Chairs
    final chairRadius = tableRadius / 3;
    for (int i = 0; i < chairsCount; i++) {
      final double angle = 2 * 3.1416 * i / chairsCount;
      final chairCenter = Offset(
        tableCenter.dx + (tableRadius + (3 / 2 * chairRadius)) * cos(angle),
        tableCenter.dy + (tableRadius + (3 / 2 * chairRadius)) * sin(angle),
      );
      canvas.drawCircle(chairCenter, chairRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
