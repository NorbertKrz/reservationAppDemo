import 'package:flutter/material.dart';
import 'square_table.dart';

class ChoosenSquareTable extends StatefulWidget {
  final double tableSize;
  final Offset tablePosition;
  final Function callback;
  final GlobalKey parentKey;
  final int maxPeople;
  const ChoosenSquareTable(
      {super.key,
      required this.tableSize,
      required this.tablePosition,
      required this.callback,
      required this.parentKey,
      required this.maxPeople});

  @override
  State<ChoosenSquareTable> createState() => _ChoosenSquareTableState();
}

class _ChoosenSquareTableState extends State<ChoosenSquareTable> {
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
                  painter: SquareTablePainter(
                      chairsCount: maxPeople,
                      widgetSize: tableSize,
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
