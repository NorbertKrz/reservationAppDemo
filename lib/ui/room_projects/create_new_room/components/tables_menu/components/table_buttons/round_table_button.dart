import 'package:flutter/material.dart';
import 'package:reservation_app/tools/enum/table_type.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/round/round_table.dart';

class RoundTableButton extends StatefulWidget {
  final Color tableColor;
  final double tableSize;
  final TableType type;
  final int chairsCount;
  final Function callbackTableInfo;

  const RoundTableButton({
    super.key,
    required this.type,
    required this.chairsCount,
    required this.tableColor,
    required this.tableSize,
    required this.callbackTableInfo,
  });

  @override
  State<RoundTableButton> createState() => RoundTableButtonState();
}

class RoundTableButtonState extends State<RoundTableButton> {
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
                    chairsAtEndsOn: false),
                true);
          });
        },
        child: CustomPaint(
          painter: RoundTablePainter(
              chairsCount: widget.chairsCount,
              widgetSize: widget.tableSize,
              color: widget.tableColor),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: widget.tableSize,
              height: widget.tableSize,
            ),
          ),
        ),
      ),
    );
  }
}
