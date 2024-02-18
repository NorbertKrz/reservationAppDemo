import 'package:flutter/material.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_data.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/listener/control_listener.dart';
import 'rectangular_long_table.dart';

class InteractiveRectangularLongTable extends StatefulWidget {
  final Function callback;
  final GlobalKey parentKey;
  final int maxPeople;
  final bool chairsAtEndsOn;
  const InteractiveRectangularLongTable(
      {super.key,
      required this.callback,
      required this.parentKey,
      required this.maxPeople,
      required this.chairsAtEndsOn});

  @override
  State<InteractiveRectangularLongTable> createState() =>
      _InteractiveRectangularLongTableState();
}

class _InteractiveRectangularLongTableState
    extends State<InteractiveRectangularLongTable> {
  Offset tableNormalizedPosition = const Offset(100, 100);
  double tableSize = 40.0;
  int maxPeople = 10;
  bool scrolling = false;
  bool showPopup = false;

  @override
  void initState() {
    setState(() {
      maxPeople = widget.maxPeople;
    });
    super.initState();
  }

  Offset updateTablePosition(
      double deltaX, double deltaY, ControlButtonsData ctrlValue) {
    if (ctrlValue.ctrlLeft) deltaX -= ctrlValue.stepMove;
    if (ctrlValue.ctrlRight) deltaX += ctrlValue.stepMove;
    if (ctrlValue.ctrlTop) deltaY -= ctrlValue.stepMove;
    if (ctrlValue.ctrlBottom) deltaY += ctrlValue.stepMove;

    return Offset(tableNormalizedPosition.dx + deltaX,
        tableNormalizedPosition.dy + deltaY);
  }

  updateTableSize(ControlButtonsData ctrlValue) {
    if (ctrlValue.zoomIn && tableSize < 120) tableSize += 5;
    if (ctrlValue.zoomOut && tableSize > 20) tableSize -= 5;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controlButtonsListener,
        builder: (BuildContext context, Widget? child) {
          ControlButtonsData ctrlValue = controlButtonsListener.value;

          double deltaX = 0;
          double deltaY = 0;

          tableNormalizedPosition =
              updateTablePosition(deltaX, deltaY, ctrlValue);
          updateTableSize(ctrlValue);

          controlButtonsListener.value.ctrlBottom = false;
          controlButtonsListener.value.ctrlTop = false;
          controlButtonsListener.value.ctrlLeft = false;
          controlButtonsListener.value.ctrlRight = false;
          controlButtonsListener.value.zoomIn = false;
          controlButtonsListener.value.zoomOut = false;
          controlButtonsListener.value.ctrlRotate = false;

          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      showPopup = !showPopup;
                      scrolling = false;
                      widget.callback(TableData(
                          tableSize: tableSize,
                          maxPeople: widget.maxPeople,
                          offset: tableNormalizedPosition,
                          scrolling: !scrolling));
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      showPopup = true;
                      scrolling = true;
                      tableNormalizedPosition += details.delta;
                      tableNormalizedPosition =
                          updateTablePosition(deltaX, deltaY, ctrlValue);
                      widget.callback(TableData(
                          tableSize: tableSize,
                          maxPeople: widget.maxPeople,
                          offset: tableNormalizedPosition,
                          scrolling: !scrolling));
                      controlButtonsListener.value = ControlButtonsData(
                          stepMove: 1,
                          ctrlLeft: false,
                          ctrlRight: false,
                          ctrlTop: false,
                          ctrlBottom: false,
                          ctrlRotate: false,
                          zoomIn: false,
                          zoomOut: false);
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      scrolling = false;
                      widget.callback(TableData(
                          tableSize: tableSize,
                          maxPeople: widget.maxPeople,
                          offset: tableNormalizedPosition,
                          scrolling: !scrolling));
                      controlButtonsListener.value = ControlButtonsData(
                          stepMove: 1,
                          ctrlLeft: false,
                          ctrlRight: false,
                          ctrlTop: false,
                          ctrlBottom: false,
                          ctrlRotate: false,
                          zoomIn: false,
                          zoomOut: false);
                    });
                  },
                  onPanDown: (details) {
                    setState(() {
                      scrolling = true;
                      widget.callback(TableData(
                          tableSize: tableSize,
                          maxPeople: widget.maxPeople,
                          offset: tableNormalizedPosition,
                          scrolling: !scrolling));
                    });
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                        left: tableNormalizedPosition.dx - tableSize * 2,
                        top: tableNormalizedPosition.dy - tableSize / 2,
                        child: CustomPaint(
                          painter: RectangularLongTablePainter(
                              chairsAtEnds: widget.chairsAtEndsOn,
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
                              width: tableSize * 4,
                              height: tableSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
