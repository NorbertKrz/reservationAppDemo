import 'package:flutter/material.dart';
import 'package:reservation_app/tools/enum/table_type.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_buttons/round_table_button.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_lists/components/divider_table_list.dart';

class RoundTableList extends StatefulWidget {
  final List<bool> visibilityList;
  final bool verticalView;
  final Function callbackTableInfo;

  const RoundTableList({
    super.key,
    required this.visibilityList,
    required this.verticalView,
    required this.callbackTableInfo,
  });

  @override
  State<RoundTableList> createState() => RoundTableListState();
}

class RoundTableListState extends State<RoundTableList> {
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
            children: roundTableList(),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: roundTableList(),
          );
  }

  List<Widget> roundTableList() {
    return [
      widget.verticalView
          ? SizedBox(
              height: space,
            )
          : SizedBox(
              width: space,
            ),
      //round 1
      Visibility(
        visible: widget.visibilityList[0],
        child: RoundTableButton(
            type: TableType.roundTable,
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

      //round 2
      Visibility(
        visible: widget.visibilityList[0],
        child: RoundTableButton(
            type: TableType.roundTable,
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

      //round 3
      Visibility(
        visible: widget.visibilityList[1],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 3,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[1],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 4
      Visibility(
        visible: widget.visibilityList[1],
        child: RoundTableButton(
            type: TableType.roundTable,
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

      //round 5
      Visibility(
        visible: widget.visibilityList[2],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 5,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 6
      Visibility(
        visible: widget.visibilityList[2],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 6,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 7
      Visibility(
        visible: widget.visibilityList[2],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 7,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 8
      Visibility(
        visible: widget.visibilityList[2],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 8,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 9
      Visibility(
        visible: widget.visibilityList[2],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 9,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[2],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 10
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 10,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 11
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 11,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 12
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 12,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 13
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 13,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 14
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 14,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
      ),
      Visibility(
          visible: widget.visibilityList[3],
          child: DividerTableList(
            verticalView: widget.verticalView,
          )),

      //round 15
      Visibility(
        visible: widget.visibilityList[3],
        child: RoundTableButton(
            type: TableType.roundTable,
            chairsCount: 15,
            tableColor: tableColor,
            tableSize: modelSize,
            callbackTableInfo: callbackTableInfo),
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
