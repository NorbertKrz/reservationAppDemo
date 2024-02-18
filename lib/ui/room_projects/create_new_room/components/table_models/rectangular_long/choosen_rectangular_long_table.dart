import 'package:flutter/material.dart';
import 'rectangular_long_table.dart';

class ChoosenRectangularLongTable extends StatefulWidget {
  final double tableSize;
  final Offset tablePosition;
  final Function callback;
  final GlobalKey parentKey;
  final int maxPeople;
  final bool chairsAtEnds;
  const ChoosenRectangularLongTable(
      {super.key,
      required this.tableSize,
      required this.tablePosition,
      required this.callback,
      required this.parentKey,
      required this.maxPeople,
      required this.chairsAtEnds});

  @override
  State<ChoosenRectangularLongTable> createState() =>
      _ChoosenRectangularLongTableState();
}

class _ChoosenRectangularLongTableState
    extends State<ChoosenRectangularLongTable> {
  double tableSize = 40.0;
  int maxPeople = 4;
  bool scrolling = false;
  late Offset tablePosition;
  bool showPopup = false;
  Offset tableNormalizedPosition = const Offset(100, 200);

  @override
  void initState() {
    setState(() {
      tablePosition = widget.tablePosition;
      tableSize = widget.tableSize;
      maxPeople = widget.maxPeople;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                left: tablePosition.dx - (tableSize) / 2,
                top: tablePosition.dy - tableSize / 2,
                child: CustomPaint(
                  painter: RectangularLongTablePainter(
                      chairsCount: maxPeople,
                      widgetSize: tableSize,
                      chairsAtEnds: widget.chairsAtEnds,
                      color: showPopup
                          ? const Color.fromARGB(255, 23, 109, 26)
                          : const Color(0xFF2446a1)),
                  child: MouseRegion(
                    cursor: scrolling
                        ? SystemMouseCursors.move
                        : SystemMouseCursors.click,
                    child: SizedBox(
                      width: tableSize,
                      height: tableSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
