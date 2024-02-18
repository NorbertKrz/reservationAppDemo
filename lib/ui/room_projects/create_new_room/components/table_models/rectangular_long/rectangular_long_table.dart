import 'package:flutter/material.dart';

class RectangularLongTablePainter extends CustomPainter {
  final int chairsCount;
  final double widgetSize;
  final Color color;
  final bool chairsAtEnds;

  RectangularLongTablePainter(
      {required this.chairsCount,
      required this.widgetSize,
      required this.color,
      required this.chairsAtEnds});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Table
    final tableWidth = widgetSize * 4;
    final tableHeight = widgetSize;
    final tableRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: tableWidth,
      height: tableHeight,
    );

    final borderRadius = widgetSize > 30
        ? BorderRadius.circular(10.0)
        : BorderRadius.circular(5.0);

    final roundedTableRect = RRect.fromRectAndCorners(
      tableRect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.drawRRect(roundedTableRect, paint);

    // Chairs
    final chairSize = widgetSize / 3;

    final chairsOnLongerSide =
        chairsAtEnds ? chairsCount / 2 - 1 : chairsCount / 2;
    final spacingBetweenChairs = (tableWidth - chairSize * chairsOnLongerSide) /
        (chairsOnLongerSide + 1);

    for (int i = 0; i < chairsOnLongerSide; i++) {
      final chairOffset =
          spacingBetweenChairs + i * (chairSize + spacingBetweenChairs);
      // top row
      canvas.drawCircle(
          Offset(tableRect.left + chairOffset + chairSize / 2,
              tableRect.top - chairSize),
          chairSize / 2,
          paint);
      // bottom row
      canvas.drawCircle(
          Offset(tableRect.left + chairOffset + chairSize / 2,
              tableRect.bottom + chairSize),
          chairSize / 2,
          paint);
    }

    if (chairsAtEnds) {
      // left side
      canvas.drawCircle(Offset(tableRect.left - chairSize, tableRect.center.dy),
          chairSize / 2, paint);
      // right side
      canvas.drawCircle(
          Offset(tableRect.right + chairSize, tableRect.center.dy),
          chairSize / 2,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
