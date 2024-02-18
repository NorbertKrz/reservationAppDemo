import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular/detailed_preview_rectangular_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/rectangular_long/detailed_preview_rectangular_long_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/round/detailed_preview_round_table.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/square/detailed_preview_square_table.dart';
import 'package:reservation_app/ui/global_elements/file_picker/file_picker_view.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';

class RoomViewScreen extends StatefulWidget {
  const RoomViewScreen({Key? key}) : super(key: key);

  @override
  State<RoomViewScreen> createState() => _RoomViewScreenState();
}

class _RoomViewScreenState extends State<RoomViewScreen>
    with TickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  double configSize = 650;
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
                  tableListWidget =
                      List.generate(roomsQuantityData, (index) => []);
                  dataTablesList =
                      List.generate(roomsQuantityData, (index) => []);
                  for (int i = 0; i < projectData.tablePositions.length; i++) {
                    for (var element in projectData.tablePositions[i]) {
                      dataTablesList[i].add({
                        'roomName': element.roomName,
                        'tableSize': element.tableSize,
                        'tableNo': element.tableNo,
                        'imageUrl': element.imageUrl,
                        'tableType': element.tableType,
                        'maxPeople': element.maxPeople,
                        'chairsAtEndsOn': element.chairsAtEndsOn,
                        'offset': {
                          'dx': element.offset.dx,
                          'dy': element.offset.dy,
                        }
                      });
                      tableListWidget[i].add(SizedBox(
                          width: configSize,
                          height: configSize,
                          child: element.tableType == TableType.squareTable.name
                              ? DetailedPreviewSquareTable(
                                  organizationReference: orgRef,
                                  tableDetailedData: element,
                                  // parentKey: parentKey,
                                )
                              : element.tableType ==
                                      TableType.rectangularTable.name
                                  ? DetailedPreviewRectangularTable(
                                      organizationReference: orgRef,
                                      tableDetailedData: element,
                                    )
                                  : element.tableType ==
                                          TableType.rectangularLongTable.name
                                      ? DetailedPreviewRectangularLongTable(
                                          organizationReference: orgRef,
                                          tableDetailedData: element,
                                        )
                                      : DetailedPreviewRoundTable(
                                          organizationReference: orgRef,
                                          tableDetailedData: element,
                                        )));
                    }
                  }
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
                                    title: 'Widok sali', path: "Podgląd sali"),
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
                                    title: 'Widok sali', path: "Podgląd sali"),
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
                                  title: 'Widok sali', path: "Podgląd sali"),
                              Expanded(
                                child: SingleChildScrollView(
                                    physics: tableData.scrolling
                                        ? const AlwaysScrollableScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child: _buildDrawBigPictureView()),
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
                  child: Container(
                    height: 1100,
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
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wybierz stolik",
                                  style: mainTextStyle.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      color: notifire.getMainText),
                                  maxLines: 2,
                                ),
                                Text(
                                    "Kliknij na wybrany stolik, aby zobaczyć szczegóły i dokonać rezerwacji.",
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
                                      "Wybierz odpowiadający Ci stolik i dokonaj rezerwacji.",
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
                                  "Wybierz stolik",
                                  style: mainTextStyle.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      color: notifire.getMainText),
                                  maxLines: 2,
                                ),
                                Text(
                                    "Kliknij na wybrany stolik, aby zobaczyć szczegóły i dokonać rezerwacji.",
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
                                      "Wybierz odpowiadający Ci stolik i dokonaj rezerwacji.",
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
