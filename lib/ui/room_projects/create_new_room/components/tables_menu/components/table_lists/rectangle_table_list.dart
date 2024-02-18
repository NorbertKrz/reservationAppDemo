import 'package:flutter/material.dart';
import 'package:reservation_app/tools/enum/table_type.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_buttons/rectangular_long_table_button.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_buttons/rectangular_table_button.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_buttons/square_table_button.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_lists/components/divider_table_list.dart';

class RectangleTableList extends StatefulWidget {
  final List<bool> visibilityList;
  final bool verticalView;
  final Function callbackTableInfo;

  const RectangleTableList({
    super.key,
    required this.visibilityList,
    required this.verticalView,
    required this.callbackTableInfo,
  });

  @override
  State<RectangleTableList> createState() => RectangleTableListState();
}

class RectangleTableListState extends State<RectangleTableList> {
  double space = 25;
  double modelSize = 20;
  bool active = false;

  callbackTableInfo(TableConfig tableConfigInput, bool activeBoolInput) {
    setState(() {
      active = activeBoolInput;
      widget.callbackTableInfo(
          TableConfig(
              type: tableConfigInput.type,
              chairsCount: tableConfigInput.chairsCount,
              chairsAtEndsOn: tableConfigInput.chairsAtEndsOn),
          active);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.verticalView
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rectangleTableList(),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rectangleTableList(),
          );
  }

  List<Widget> rectangleTableList() {
    return [
      widget.verticalView
          ? SizedBox(
              height: space,
            )
          : SizedBox(
              width: space,
            ),
      //square 1
      Visibility(
        visible: widget.visibilityList[0],
        child: SquareTableButton(
            type: TableType.squareTable,
            chairsCount: 1,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[0],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //square 2
      Visibility(
        visible: widget.visibilityList[0],
        child: SquareTableButton(
            type: TableType.squareTable,
            chairsCount: 2,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[0],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 2
      Visibility(
        visible: widget.visibilityList[0],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 2,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[0],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //square 4
      Visibility(
        visible: widget.visibilityList[1],
        child: SquareTableButton(
            type: TableType.squareTable,
            chairsCount: 4,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[1],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 4 (with ends)
      Visibility(
        visible: widget.visibilityList[1],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 4,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[1],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 4
      Visibility(
        visible: widget.visibilityList[1],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 4,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[1],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 6 (with ends)
      Visibility(
        visible: widget.visibilityList[2],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 6,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 6
      Visibility(
        visible: widget.visibilityList[2],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 6,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 8 (with ends)
      Visibility(
        visible: widget.visibilityList[2],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 8,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 8
      Visibility(
        visible: widget.visibilityList[2],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 8,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 10 (with ends)
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 10,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 10 (with ends)
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularTableButton(
            type: TableType.rectangularTable,
            chairsCount: 10,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 12 (with ends)
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularLongTableButton(
            type: TableType.rectangularLongTable,
            chairsCount: 12,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 12
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularLongTableButton(
            type: TableType.rectangularLongTable,
            chairsCount: 12,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 14 (with ends)
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularLongTableButton(
            type: TableType.rectangularLongTable,
            chairsCount: 14,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: true),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //rectangle 14
      Visibility(
        visible: widget.visibilityList[3],
        child: RectangularLongTableButton(
            type: TableType.rectangularLongTable,
            chairsCount: 14,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo,
            chairsAtEndsOn: false),
      ),
      widget.verticalView
          ? SizedBox(
              height: space * 2,
            )
          : SizedBox(
              width: space * 2,
            )
    ];
  }
}
