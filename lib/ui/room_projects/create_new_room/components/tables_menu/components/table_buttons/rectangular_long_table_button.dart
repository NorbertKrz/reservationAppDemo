import 'package:flutter/material.dart';
import 'package:reservation_app/tools/enum/table_type.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular_long/rectangular_long_table.dart';

class RectangularLongTableButton extends StatefulWidget {
  final Color tableColor;
  final double tableSize;
  final TableType type;
  final int chairsCount;
  final bool chairsAtEndsOn;
  final Function callbackTableInfo;

  const RectangularLongTableButton({
    super.key,
    required this.type,
    required this.chairsCount,
    required this.tableColor,
    required this.tableSize,
    required this.callbackTableInfo,
    required this.chairsAtEndsOn,
  });

  @override
  State<RectangularLongTableButton> createState() =>
      RectangularLongTableButtonState();
}

class RectangularLongTableButtonState
    extends State<RectangularLongTableButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Liczba osób: ${widget.chairsCount}',
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.callbackTableInfo(
                TableConfig(
                    type: widget.type,
                    chairsCount: widget.chairsCount,
                    chairsAtEndsOn: widget.chairsAtEndsOn),
                true);
          });
        },
        child: CustomPaint(
          painter: RectangularLongTablePainter(
              chairsAtEnds: widget.chairsAtEndsOn,
              chairsCount: widget.chairsCount,
              widgetSize: widget.tableSize,
              color: widget.tableColor),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: 4 * widget.tableSize,
              height: widget.tableSize,
            ),
          ),
        ),
      ),
    );
  }
}
