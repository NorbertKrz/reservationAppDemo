import 'package:flutter/material.dart';

class SquareTablePainter extends CustomPainter {
  final int chairsCount;
  final double widgetSize;
  final Color color;

  SquareTablePainter(
      {required this.chairsCount,
      required this.widgetSize,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Table
    final tableWidth = widgetSize;
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

    final chairsOnLongerSide = chairsCount / 2 - 1;
    final spacingBetweenChairs = (tableWidth - chairSize * chairsOnLongerSide) /
        (chairsOnLongerSide + 1);

    if (chairsCount > 1) {
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
      // left side
      canvas.drawCircle(Offset(tableRect.left - chairSize, tableRect.center.dy),
          chairSize / 2, paint);
      // right side
      canvas.drawCircle(
          Offset(tableRect.right + chairSize, tableRect.center.dy),
          chairSize / 2,
          paint);
    } else {
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
