import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:polygon/polygon.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/table_type.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_data.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular/choosen_rectangular_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular/interactive_rectangular_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular_long/choosen_rectangular_long_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/round/choosen_round_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/round/interactive_round_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/square/choosen_square_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/square/interactive_square_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/table_menu.dart';
import 'package:reservation_app/ui/global_elements/file_picker/file_picker_view.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'components/table_models/rectangular_long/interactive_rectangular_long_table.dart';

class CreateNewRoomStep3Screen extends StatefulWidget {
  const CreateNewRoomStep3Screen({Key? key}) : super(key: key);

  @override
  State<CreateNewRoomStep3Screen> createState() =>
      _CreateNewRoomStep3ScreenState();
}

class _CreateNewRoomStep3ScreenState extends State<CreateNewRoomStep3Screen>
    with TickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  double configSize = 500;
  bool rightAngleMode = true;
  late List<String> _roomNameList;
  late List<int> _roomLevelList;
  final ValueNotifier _listenerRoomAmount = ValueNotifier(0);
  late TabController _tabCtrlRoom;

  List<Polygon> polygonList = [];

  List<Widget> roomSwitch = [];
  List<Widget> listWidgetField = [];
  List<Widget> listWidgetFile = [];
  List<Widget> listRoomName = [];
  late DocumentReference orgRef;
  int roomsQuantityData = 0;
  int levelsQuantityData = 0;
  double maxWidth = 300;
  int maxPeople = 8;
  late TableData tableData;
  GlobalKey<FormState> parentKey = GlobalKey<FormState>();
  List<List<Widget>> tableListWidget = [];
  Widget? activeTableWidget;
  List<List<Map>> dataTablesList = [];
  late TableConfig tableType;

  callbackInteractiveWidget(TableData object) {
    setState(() {
      tableData = object;
    });
  }

  callbackConfirmTable(Map confirmData) {
    setState(() {
      if (!confirmData['confirmState']) {
        dataTablesList[_tabCtrlRoom.index].add({
          'roomName': _roomNameList[_tabCtrlRoom.index],
          'tableSize': tableData.tableSize,
          'tableNo': confirmData['tableNo'],
          'imageUrl': confirmData['imageUrl'],
          'tableType': tableType.type.name,
          'maxPeople': tableType.chairsCount,
          'chairsAtEndsOn': tableType.chairsAtEndsOn,
          'offset': {
            'dx': tableData.offset.dx,
            'dy': tableData.offset.dy,
          }
        });

        tableListWidget[_tabCtrlRoom.index].add(SizedBox(
            width: configSize,
            height: configSize,
            child: tableType.type == TableType.squareTable
                ? ChoosenSquareTable(
                    tableSize: tableData.tableSize,
                    tablePosition:
                        Offset(tableData.offset.dx, tableData.offset.dy),
                    callback: callbackInteractiveWidget,
                    parentKey: parentKey,
                    maxPeople: tableType.chairsCount)
                : tableType.type == TableType.rectangularTable
                    ? ChoosenRectangularTable(
                        tableSize: tableData.tableSize,
                        tablePosition:
                            Offset(tableData.offset.dx, tableData.offset.dy),
                        callback: callbackInteractiveWidget,
                        parentKey: parentKey,
                        maxPeople: tableType.chairsCount,
                        chairsAtEnds: tableType.chairsAtEndsOn,
                      )
                    : tableType.type == TableType.rectangularLongTable
                        ? ChoosenRectangularLongTable(
                            tableSize: tableData.tableSize,
                            tablePosition: Offset(
                                tableData.offset.dx, tableData.offset.dy),
                            callback: callbackInteractiveWidget,
                            parentKey: parentKey,
                            maxPeople: tableType.chairsCount,
                            chairsAtEnds: tableType.chairsAtEndsOn)
                        : ChoosenRoundTable(
                            tableSize: tableData.tableSize,
                            tablePosition: Offset(
                                tableData.offset.dx, tableData.offset.dy),
                            callback: callbackInteractiveWidget,
                            parentKey: parentKey,
                            maxPeople: tableType.chairsCount)));
      }
      activeTableWidget = null;
    });
  }

  callbackTableType(TableConfig object) {
    setState(() {
      tableType = object;
      Widget tableWidget;
      switch (tableType.type) {
        case TableType.squareTable:
          tableWidget = InteractiveSquareTable(
            callback: callbackInteractiveWidget,
            parentKey: parentKey,
            maxPeople: tableType.chairsCount,
          );
        case TableType.rectangularTable:
          tableWidget = InteractiveRectangularTable(
            chairsAtEndsOn: tableType.chairsAtEndsOn,
            callback: callbackInteractiveWidget,
            parentKey: parentKey,
            maxPeople: tableType.chairsCount,
          );
        case TableType.rectangularLongTable:
          tableWidget = InteractiveRectangularLongTable(
            chairsAtEndsOn: tableType.chairsAtEndsOn,
            callback: callbackInteractiveWidget,
            parentKey: parentKey,
            maxPeople: tableType.chairsCount,
          );
        case TableType.roundTable:
          tableWidget = InteractiveRoundTable(
            callback: callbackInteractiveWidget,
            parentKey: parentKey,
            maxPeople: tableType.chairsCount,
          );
      }
      activeTableWidget =
          SizedBox(width: configSize, height: configSize, child: tableWidget);
    });
  }

  @override
  void dispose() {
    _tabCtrlRoom.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tableData = TableData(
      scrolling: true,
      offset: const Offset(0, 0),
      maxPeople: maxPeople,
      tableSize: 40,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            if (state.user.accountData!.plan == Plan.pro) {
              orgRef = orgRefListener.value!;
            } else {
              orgRef = state.user.organizationRef!;
            }
          }
          return BlocBuilder<OrganizationBloc, OrganizationState>(
            builder: (context, state) {
              if (state is OrganizationPobrane) {
                ProjectData projectData = state.organization
                    .firstWhere((element) => element.ref == orgRef)
                    .projectData;
                if (polygonList.isEmpty) {
                  roomSwitch.clear();
                  roomsQuantityData = state.organization
                      .firstWhere((element) => element.ref == orgRef)
                      .general
                      .roomQuantity;
                  levelsQuantityData = state.organization
                      .firstWhere((element) => element.ref == orgRef)
                      .general
                      .levelQuantity;
                  dataTablesList =
                      List.generate(roomsQuantityData, (index) => []);
                  _roomNameList = List.generate(roomsQuantityData,
                      (index) => projectData.rooms[index].roomName);
                  _roomLevelList = List.generate(roomsQuantityData,
                      (index) => projectData.rooms[index].roomLevel.toInt());

                  List tempVert = [];
                  for (int i = 0; i < projectData.rooms.length; i++) {
                    tempVert
                        .add(projectData.rooms[i].offsetList.map((offsetMap) {
                      return Offset(offsetMap["dx"], offsetMap["dy"]);
                    }).toList());
                  }
                  tableListWidget =
                      List.generate(roomsQuantityData, (index) => []);
                  polygonList = List.generate(
                      roomsQuantityData, (index) => Polygon(tempVert[index]));

                  _tabCtrlRoom =
                      TabController(length: roomsQuantityData, vsync: this);
                  for (int i = 0; i < roomsQuantityData; i++) {
                    roomSwitch.add(Text((i + 1).toString()));
                  }
                }
              }
              return Container(
                decoration: boxDecoration,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    maxWidth = constraints.maxWidth * 0.9;
                    if (constraints.maxWidth >= 1200) {
                      configSize = 650;
                    } else if (constraints.maxWidth >= 600 &&
                        constraints.maxWidth < 1200) {
                      configSize = 500;
                    } else {
                      configSize = 350;
                    }
                    if (constraints.maxWidth < 600) {
                      return Container(
                          color: notifire.getbgcolor,
                          height: 1400,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const PathViewTitle(
                                    title: 'Widok sali', path: "Projekt sali"),
                                SingleChildScrollView(
                                    physics: tableData.scrolling
                                        ? const AlwaysScrollableScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child:
                                        _buildDrawMediumAndSmallPictureView()),
                              ],
                            ),
                          ));
                    } else if (constraints.maxWidth < 1000) {
                      return Container(
                          color: notifire.getbgcolor,
                          height: 1400,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const PathViewTitle(
                                    title: 'Widok sali', path: "Projekt sali"),
                                SingleChildScrollView(
                                    physics: tableData.scrolling
                                        ? const AlwaysScrollableScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child:
                                        _buildDrawMediumAndSmallPictureView()),
                              ],
                            ),
                          ));
                    } else {
                      return Container(
                          color: notifire.getbgcolor,
                          height: 900,
                          width: double.infinity,
                          child: Column(
                            children: [
                              const PathViewTitle(
                                  title: 'Widok sali', path: "Projekt sali"),
                              Expanded(
                                child: Stack(children: [
                                  SingleChildScrollView(
                                      physics: tableData.scrolling
                                          ? const AlwaysScrollableScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      child: _buildDrawBigPictureView()),
                                  Positioned(
                                      right: 20,
                                      top: 20,
                                      child: TableMenu(
                                          verticalView: true,
                                          tableInfo: callbackTableType,
                                          confirm: callbackConfirmTable))
                                ]),
                              ),
                            ],
                          ));
                    }
                  }),
                ),
              );
            },
          );
        },
      )),
    );
  }

  Widget _buildDrawBigPictureView() {
    return GetBuilder<AppConst>(builder: (controller) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ValueListenableBuilder(
              valueListenable: _listenerRoomAmount,
              builder: (context, value, child) {
                listWidgetFile.clear();
                listWidgetField.clear();
                listRoomName.clear();
                listWidgetFile = List.generate(
                    roomsQuantityData, (index) => const FilePickerView());
                listWidgetField = List.generate(
                    roomsQuantityData,
                    (index) => drawField(
                          polygonList[index],
                          tableListWidget[index],
                        ));
                listRoomName = List.generate(roomsQuantityData, (index) {
                  return buildTextNameAndLevels(
                    name: _roomNameList[index],
                    level: _roomLevelList[index],
                    width: maxWidth * 0.85,
                  );
                });
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 320.0),
                    child: Container(
                      height: 1100,
                      decoration: BoxDecoration(
                        color: notifire.getcontiner,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rozmieść stoliki dla gości",
                                    style: mainTextStyle.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        color: notifire.getMainText),
                                    maxLines: 2,
                                  ),
                                  Text(
                                      "Przy pomocy modeli stołów odwzoruj układ w Twojej restauracji.",
                                      style: mediumGreyTextStyle.copyWith(
                                          fontSize: 16),
                                      maxLines: 2),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SizedBox(
                                height: 30,
                                width: configSize,
                                child: IndexedStack(
                                  index: _tabCtrlRoom.index,
                                  children: listRoomName,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Na stworzonym wcześniej projekcie sali, rozmieść odpowiednio stoliki dla gości.",
                                        textAlign: TextAlign.center,
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 14),
                                        softWrap: true,
                                        maxLines: 2),
                                  ),
                                  SizedBox(
                                    key: parentKey,
                                    width: configSize,
                                    height: configSize,
                                    child: IndexedStack(
                                        index: _tabCtrlRoom.index,
                                        children: listWidgetField),
                                  ),
                                  const SizedBox(height: 2),
                                  Visibility(
                                    visible: roomsQuantityData > 1,
                                    child: Column(
                                      children: [
                                        _switchRoomsText(),
                                        Container(
                                          height: 50,
                                          width: 320,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: const Color(0xff161D26),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TabBar(
                                              controller: _tabCtrlRoom,
                                              labelPadding:
                                                  const EdgeInsets.all(8),
                                              indicator: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: appMainColor,
                                              ),
                                              onTap: (value) {
                                                setState(() {
                                                  _listenerRoomAmount.value =
                                                      value;
                                                });
                                              },
                                              dividerColor: Colors.transparent,
                                              tabs: roomSwitch),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  nextStepButton(controller),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }));
    });
  }

  Widget _buildDrawMediumAndSmallPictureView() {
    return GetBuilder<AppConst>(builder: (controller) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ValueListenableBuilder(
              valueListenable: _listenerRoomAmount,
              builder: (context, value, child) {
                listWidgetFile.clear();
                listWidgetField.clear();
                listRoomName.clear();
                listWidgetFile = List.generate(
                    roomsQuantityData, (index) => const FilePickerView());
                listWidgetField = List.generate(
                    roomsQuantityData,
                    (index) => drawField(
                          polygonList[index],
                          tableListWidget[index],
                        ));
                listRoomName = List.generate(roomsQuantityData, (index) {
                  return buildTextNameAndLevels(
                    name: _roomNameList[index],
                    level: _roomLevelList[index],
                    width: maxWidth * 0.85,
                  );
                });
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 1300,
                    decoration: BoxDecoration(
                      color: notifire.getcontiner,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 68,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rozmieść stoliki dla gości",
                                  style: mainTextStyle.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      color: notifire.getMainText),
                                  maxLines: 2,
                                ),
                                Text(
                                    "Przy pomocy modeli stołów odwzoruj układ w Twojej restauracji.",
                                    style: mediumGreyTextStyle.copyWith(
                                        fontSize: 16),
                                    maxLines: 2),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: configSize,
                              child: IndexedStack(
                                index: _tabCtrlRoom.index,
                                children: listRoomName,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Na stworzonym wcześniej projekcie sali, rozmieść odpowiednio stoliki dla gości.",
                                      textAlign: TextAlign.center,
                                      style: mediumGreyTextStyle.copyWith(
                                          fontSize: 14),
                                      softWrap: true,
                                      maxLines: 2),
                                ),
                                SizedBox(
                                  key: parentKey,
                                  width: configSize,
                                  height: configSize,
                                  child: IndexedStack(
                                      index: _tabCtrlRoom.index,
                                      children: listWidgetField),
                                ),
                                const SizedBox(height: 2),
                                TableMenu(
                                    verticalView: false,
                                    tableInfo: callbackTableType,
                                    confirm: callbackConfirmTable),
                                Visibility(
                                  visible: roomsQuantityData > 1,
                                  child: Column(
                                    children: [
                                      _switchRoomsText(),
                                      Container(
                                        height: 50,
                                        width: 320,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff161D26),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TabBar(
                                            controller: _tabCtrlRoom,
                                            labelPadding:
                                                const EdgeInsets.all(8),
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: appMainColor,
                                            ),
                                            onTap: (value) {
                                              setState(() {
                                                _listenerRoomAmount.value =
                                                    value;
                                              });
                                            },
                                            dividerColor: Colors.transparent,
                                            tabs: roomSwitch),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                nextStepButton(controller),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }));
    });
  }

  Widget drawField(Polygon polygon, List<Widget> tableWidgets) {
    return DragTarget<int>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Column(
          children: [
            polygon.vertices.isNotEmpty
                ? Stack(
                    children: [
                      Container(
                        key: ValueKey(polygon.vertices.toString()),
                        width: configSize,
                        height: configSize,
                        decoration: BoxDecoration(
                            color: notifire.getGridPaperColor,
                            border: Border.all(
                              color: notifire.getGridColor,
                            )),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                              shape: PolygonBorder(
                                polygon: polygon,
                                turn: 0,
                                radius: 5.0,
                                borderAlign: BorderAlign.outside,
                                side: BorderSide(
                                  width: 1.5,
                                  color: notifire.getPolygonBorderColor,
                                ),
                              ),
                              color: notifire.getPolygonColor),
                          child: const SizedBox(
                            height: 200,
                            width: 200,
                          ),
                        ),
                      ),
                      tableWidgets.isNotEmpty
                          ? Stack(children: tableWidgets)
                          : const Text(''),
                      activeTableWidget != null
                          ? activeTableWidget!
                          : const Text('')
                    ],
                  )
                : Container(
                    key: ValueKey(polygon.vertices.length.toString()),
                    width: configSize,
                    height: configSize,
                    decoration: BoxDecoration(
                        color: notifire.getGridPaperColor,
                        border: Border.all(
                          color: notifire.getGridColor,
                        )),
                  ),
          ],
        );
      },
    );
  }

  nextStepButton(AppConst controller) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width * 0.6
            : MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
            onPressed: () async {
              for (int i = 0; i < dataTablesList.length; i++) {
                await orgRef.set({
                  'projectData': {
                    'tablePositions': {'$i': dataTablesList[i]}
                  }
                }, SetOptions(merge: true));
              }
              await orgRef.set({
                'processData': {
                  'creationStatus': {
                    'step': 3,
                    'status': 'done',
                  }
                }
              }, SetOptions(merge: true));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                backgroundColor: appMainColor,
                elevation: 0,
                fixedSize: const Size.fromHeight(60)),
            child: Row(
              children: [
                const Expanded(
                    child: SizedBox(
                  width: 10,
                )),
                Text(
                  "Przejdź dalej",
                  style: mediumGreyTextStyle.copyWith(color: Colors.white),
                ),
                const Expanded(
                    child: SizedBox(
                  width: 10,
                )),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: SvgPicture.asset(
                    "assets/arrow-right-small.svg",
                    width: 12,
                    height: 12,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  )),
                ),
              ],
            )),
      ),
    );
  }

  Widget _switchRoomsText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 40,
                child: Divider(
                  color: notifire.getMainText,
                  height: 20,
                  thickness: 1,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Przełącz na widok innej sali",
              style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
                width: 40,
                child: Divider(
                  color: notifire.getMainText,
                  height: 20,
                  thickness: 1,
                )),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget buildTextNameAndLevels(
      {required String name, required double width, required int level}) {
    return Center(
      child: SizedBox(
          width: width,
          child: Text(
            "$name (poziom: $level)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: notifire.getMainText),
          )),
    );
  }
}
