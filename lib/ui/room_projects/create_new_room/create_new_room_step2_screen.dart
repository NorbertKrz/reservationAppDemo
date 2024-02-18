import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:polygon/polygon.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/file_picker/file_picker_view.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';

class CreateNewRoomStep2Screen extends StatefulWidget {
  const CreateNewRoomStep2Screen({Key? key}) : super(key: key);

  @override
  State<CreateNewRoomStep2Screen> createState() =>
      _CreateNewRoomStep2ScreenState();
}

class _CreateNewRoomStep2ScreenState extends State<CreateNewRoomStep2Screen>
    with TickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  double configSize = 500;
  bool rightAngleMode = true;
  bool gridMode = true;
  late List<TextEditingController> _ctrlRoomName;
  late List<TextEditingController> _ctrlRoomLevel;
  final ValueNotifier _listenerRoomAmount = ValueNotifier(0);
  late TabController _tabCtrlProjectType;
  late TabController _tabCtrlRoom;
  String gridSettings = 'Średnio';
  List<String> gridType = [
    'Rzadko',
    'Średnio',
    'Gęsto',
  ];

  List<Polygon> polygonList = [];
  double firstPointPosX = 0;
  double firstPointPosY = 0;
  final double _startPointIcon = 10;
  List<Widget> roomSwitch = [];
  List<Widget> listWidgetField = [];
  List<Widget> listWidgetFile = [];
  List<Widget> listRoomName = [];
  late DocumentReference orgRef;
  int roomsQuantityData = 0;
  int levelsQuantityData = 0;
  double maxWidth = 300;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
          // backgroundColor: appBgColor,
          body: BlocBuilder<UserBloc, UserState>(
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
                  _ctrlRoomName = List.generate(
                      roomsQuantityData, (index) => TextEditingController());
                  _ctrlRoomLevel = List.generate(
                      roomsQuantityData, (index) => TextEditingController());
                  polygonList =
                      // ignore: prefer_const_constructors
                      List.generate(roomsQuantityData, (index) => Polygon([]));
                  _tabCtrlProjectType = TabController(length: 2, vsync: this);
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
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const PathViewTitle(
                                      title: 'Widok sali',
                                      path: "Projekt sali"),
                                  _buildDrawSmallPictureView(),
                                ],
                              )));
                    } else if (constraints.maxWidth < 1000) {
                      return Container(
                          color: notifire.getbgcolor,
                          height: 1400,
                          width: double.infinity,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const PathViewTitle(
                                      title: 'Widok sali',
                                      path: "Projekt sali"),
                                  _buildDrawMediumPictureView(),
                                ],
                              )));
                    } else {
                      return Container(
                          color: notifire.getbgcolor,
                          height: 900,
                          width: double.infinity,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const PathViewTitle(
                                      title: 'Widok sali',
                                      path: "Projekt sali"),
                                  _buildDrawBigPictureView(),
                                ],
                              )));
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
                listWidgetField = List.generate(roomsQuantityData,
                    (index) => drawField(polygonList[index]));
                listRoomName = List.generate(roomsQuantityData, (index) {
                  return buildTextFieldNameAndLevels(
                      hinttext:
                          "Nazwa aktualnego widoku sali, np. (Sala główna $index)",
                      icon: Icons.title_outlined,
                      controller: _ctrlRoomName[_tabCtrlRoom.index],
                      levelsAmount: levelsQuantityData,
                      width: configSize,
                      levelController: _ctrlRoomLevel[_tabCtrlRoom.index]);
                });
                return Container(
                  height: 1200,
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
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stwórz swój własny widok sali",
                                      style: mainTextStyle.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          color: notifire.getMainText),
                                      maxLines: 2,
                                    ),
                                    Text(
                                        "Odwzoruj za pomocą poniższych narzędzi widok przedstawiający salę Twojej restauracji.",
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Wgraj gotowy plan z widokiem sali",
                                        style: mainTextStyle.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: notifire.getMainText),
                                        maxLines: 2),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                        'Masz gotowy plan budynku/sali? Możesz go wgrać poniżej.',
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 50,
                            width: 320,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: const Color(0xff161D26),
                                borderRadius: BorderRadius.circular(20)),
                            child: TabBar(
                                controller: _tabCtrlProjectType,
                                labelPadding: const EdgeInsets.all(8),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: appMainColor,
                                ),
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Text('Stwórz projekt'),
                                  Text('Wgraj plan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: SizedBox(
                            height: 70,
                            width: 600,
                            child: TabBarView(
                              controller: _tabCtrlRoom,
                              children: listRoomName,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Flexible(
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //draw menu - options
                                        Expanded(child: drawMenuLeft()),
                                        SizedBox(
                                          width: configSize,
                                          height: configSize + 40,
                                          child: TabBarView(
                                              controller: _tabCtrlRoom,
                                              children: listWidgetField),
                                        ),
                                        Expanded(
                                            child: drawMenuRight(polygonList[
                                                _tabCtrlRoom.index])),
                                      ],
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
                                                dividerColor:
                                                    Colors.transparent,
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
                                Column(
                                  children: [
                                    SizedBox(
                                      width: configSize,
                                      height: 200,
                                      child: TabBarView(
                                          controller: _tabCtrlRoom,
                                          children: listWidgetFile),
                                    ),
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
                                          labelPadding: const EdgeInsets.all(8),
                                          indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: appMainColor,
                                          ),
                                          onTap: (value) {
                                            setState(() {
                                              _listenerRoomAmount.value = value;
                                            });
                                          },
                                          dividerColor: Colors.transparent,
                                          tabs: roomSwitch),
                                    ),
                                  ],
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                );
              }));
    });
  }

  Widget _buildDrawMediumPictureView() {
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
                listWidgetField = List.generate(roomsQuantityData,
                    (index) => drawField(polygonList[index]));
                listRoomName = List.generate(roomsQuantityData, (index) {
                  return buildTextFieldNameAndLevels(
                      hinttext:
                          "Nazwa aktualnego widoku sali, np. (Sala główna $index)",
                      icon: Icons.title_outlined,
                      controller: _ctrlRoomName[_tabCtrlRoom.index],
                      levelsAmount: levelsQuantityData,
                      width: maxWidth * 0.85,
                      levelController: _ctrlRoomLevel[_tabCtrlRoom.index]);
                });
                return Container(
                  height: 1250,
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
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stwórz swój własny widok sali",
                                      style: mainTextStyle.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          color: notifire.getMainText),
                                      maxLines: 2,
                                    ),
                                    Text(
                                        "Odwzoruj za pomocą poniższych narzędzi widok przedstawiający salę Twojej restauracji.",
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Wgraj gotowy plan z widokiem sali",
                                        style: mainTextStyle.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: notifire.getMainText),
                                        maxLines: 2),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                        'Masz gotowy plan budynku/sali? Możesz go wgrać poniżej.',
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Container(
                            height: 50,
                            width: 320,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: const Color(0xff161D26),
                                borderRadius: BorderRadius.circular(20)),
                            child: TabBar(
                                controller: _tabCtrlProjectType,
                                labelPadding: const EdgeInsets.all(8),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: appMainColor,
                                ),
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Text('Stwórz projekt'),
                                  Text('Wgraj zdjęcie',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: SizedBox(
                            height: 70,
                            width: 1000,
                            child: TabBarView(
                              controller: _tabCtrlRoom,
                              children: listRoomName,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Flexible(
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        //draw menu - options
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Center(child: drawMenuLeft()),
                                            Center(
                                                child: drawMenuRight(
                                                    polygonList[
                                                        _tabCtrlRoom.index])),
                                          ],
                                        ),
                                        SizedBox(
                                          width: configSize,
                                          height: configSize + 40,
                                          child: TabBarView(
                                              controller: _tabCtrlRoom,
                                              children: listWidgetField),
                                        ),
                                      ],
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
                                                dividerColor:
                                                    Colors.transparent,
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
                                Column(
                                  children: [
                                    SizedBox(
                                      width: configSize,
                                      height: 200,
                                      child: TabBarView(
                                          controller: _tabCtrlRoom,
                                          children: listWidgetFile),
                                    ),
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
                                          labelPadding: const EdgeInsets.all(8),
                                          indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: appMainColor,
                                          ),
                                          onTap: (value) {
                                            setState(() {
                                              _listenerRoomAmount.value = value;
                                            });
                                          },
                                          dividerColor: Colors.transparent,
                                          tabs: roomSwitch),
                                    ),
                                  ],
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                );
              }));
    });
  }

  Widget _buildDrawSmallPictureView() {
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
                listWidgetField = List.generate(roomsQuantityData,
                    (index) => drawField(polygonList[index]));
                listRoomName = List.generate(roomsQuantityData, (index) {
                  return buildTextFieldNameAndLevels(
                      hinttext:
                          "Nazwa aktualnego widoku sali, np. (Sala główna $index)",
                      icon: Icons.title_outlined,
                      controller: _ctrlRoomName[_tabCtrlRoom.index],
                      levelsAmount: levelsQuantityData,
                      width: maxWidth * 0.9,
                      levelController: _ctrlRoomLevel[_tabCtrlRoom.index]);
                });
                return Container(
                  height: 1200,
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
                          height: 70,
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stwórz swój własny widok sali",
                                      style: mainTextStyle.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          color: notifire.getMainText),
                                      maxLines: 2,
                                    ),
                                    Text(
                                        "Odwzoruj za pomocą poniższych narzędzi widok przedstawiający salę Twojej restauracji.",
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Wgraj plan z widokiem sali",
                                        style: mainTextStyle.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: notifire.getMainText),
                                        maxLines: 2),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                        'Masz gotowy plan budynku/sali? Możesz go wgrać poniżej.',
                                        style: mediumGreyTextStyle.copyWith(
                                            fontSize: 16),
                                        maxLines: 2),
                                  ],
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        Center(
                          child: Container(
                            height: 50,
                            width: 320,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: const Color(0xff161D26),
                                borderRadius: BorderRadius.circular(20)),
                            child: TabBar(
                                controller: _tabCtrlProjectType,
                                labelPadding: const EdgeInsets.all(8),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: appMainColor,
                                ),
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Text('Stwórz projekt'),
                                  Text('Wgraj zdjęcie',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        Center(
                          child: SizedBox(
                            height: 70,
                            width: 600,
                            child: TabBarView(
                              controller: _tabCtrlRoom,
                              children: listRoomName,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        Flexible(
                          child: TabBarView(
                              controller: _tabCtrlProjectType,
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //draw menu - options
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: drawMenuLeft())),
                                            Expanded(
                                                child: Center(
                                                    child: drawMenuRight(
                                                        polygonList[_tabCtrlRoom
                                                            .index]))),
                                          ],
                                        ),
                                        SizedBox(
                                          width: configSize,
                                          height: configSize + 50,
                                          child: TabBarView(
                                              controller: _tabCtrlRoom,
                                              children: listWidgetField),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
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
                                                dividerColor:
                                                    Colors.transparent,
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
                                Column(
                                  children: [
                                    SizedBox(
                                      width: configSize,
                                      height: 200,
                                      child: TabBarView(
                                          controller: _tabCtrlRoom,
                                          children: listWidgetFile),
                                    ),
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
                                          labelPadding: const EdgeInsets.all(8),
                                          indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: appMainColor,
                                          ),
                                          onTap: (value) {
                                            setState(() {
                                              _listenerRoomAmount.value = value;
                                            });
                                          },
                                          dividerColor: Colors.transparent,
                                          tabs: roomSwitch),
                                    ),
                                  ],
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                );
              }));
    });
  }

  Widget drawField(Polygon polygon) {
    return DragTarget<int>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        if (polygon.vertices.isNotEmpty) {
          firstPointPosX = (polygon.vertices.first.dx + 1) * configSize / 2;
          firstPointPosY = (polygon.vertices.first.dy + 1) * configSize / 2;
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Na poniższym arkuszu stwórz pojekt sali Twojej restauracji",
                  textAlign: TextAlign.center,
                  style: mediumGreyTextStyle.copyWith(fontSize: 14),
                  softWrap: true,
                  maxLines: 2),
            ),
            Listener(
              onPointerDown: (PointerDownEvent event) {
                double offsetX = event.localPosition.dx * 2 / configSize - 1;
                double offsetY = event.localPosition.dy * 2 / configSize - 1;
                double differencePosX =
                    (event.localPosition.dx - firstPointPosX).abs();
                double differencePosY =
                    (event.localPosition.dy - firstPointPosY).abs();
                double radiusPos =
                    sqrt(pow(differencePosX, 2) + pow(differencePosY, 2));
                // polygon
                setState(() {
                  if (polygon.vertices.isEmpty) {
                    drawMode(rightAngleMode, polygon, offsetX, offsetY);
                  } else if ((radiusPos > _startPointIcon * 2)) {
                    drawMode(rightAngleMode, polygon, offsetX, offsetY);
                  } else {
                    debugPrint('drawMode OFF');
                  }
                  firstPointPosX =
                      (polygon.vertices.first.dx + 1) * configSize / 2;
                  firstPointPosY =
                      (polygon.vertices.first.dy + 1) * configSize / 2;
                });
              },
              onPointerHover: (PointerHoverEvent event) {},
              child: polygon.vertices.isNotEmpty
                  ? Stack(
                      children: [
                        GridPaper(
                          interval: gridSettings == gridType[0]
                              ? 200
                              : gridSettings == gridType[1]
                                  ? 100
                                  : 40,
                          divisions: 1,
                          color: gridMode
                              ? notifire.getGridColor
                              : Colors.transparent,
                          child: Container(
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
                        ),
                        Positioned(
                            key: ValueKey(firstPointPosY.toString()),
                            top: firstPointPosY - 15,
                            left: firstPointPosX - 15,
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(125, 158, 158, 158),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    iconSize: 30,
                                    autofocus: true,
                                    onPressed: polygon.vertices.length > 3 &&
                                            !(polygon.vertices.first.dx ==
                                                    polygon.vertices.last.dx ||
                                                polygon.vertices.first.dy ==
                                                    polygon.vertices.last.dy)
                                        ? () {
                                            setState(() {
                                              endDraw(polygon);
                                            });
                                          }
                                        : null,
                                    icon: Icon(
                                      size: _startPointIcon,
                                      Icons.circle,
                                      color: appMainColor,
                                    ),
                                    tooltip: polygon.vertices.length > 3 &&
                                            !(polygon.vertices.first.dx ==
                                                    polygon.vertices.last.dx ||
                                                polygon.vertices.first.dy ==
                                                    polygon.vertices.last.dy)
                                        ? "Zakończ rysowanie"
                                        : "Punkt startowy"))),
                      ],
                    )
                  : GridPaper(
                      interval: gridSettings == gridType[0]
                          ? 200
                          : gridSettings == gridType[1]
                              ? 100
                              : 40,
                      divisions: 1,
                      color:
                          gridMode ? notifire.getGridColor : Colors.transparent,
                      child: Container(
                        key: ValueKey(polygon.vertices.length.toString()),
                        width: configSize,
                        height: configSize,
                        decoration: BoxDecoration(
                            color: notifire.getGridPaperColor,
                            border: Border.all(
                              color: notifire.getGridColor,
                            )),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _buildDialogDeleteAll(Polygon polygon) {
    return showDialog(
      context: context,
      anchorPoint: const Offset(200, 389),
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: notifire.getcontiner,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Czy na pewno chcesz wszystko usunąć?",
                              style: mediumGreyTextStyle.copyWith(
                                  fontSize: 18, color: notifire.getMainText)),
                          Material(
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.close_outlined,
                                  size: 20,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Text(
                        "Usunięcie spowoduje wyczyszczenie całego dotychczas utworzonego projektu i będzie nieodwracalne.",
                        softWrap: true,
                        style: mediumGreyTextStyle.copyWith(
                            color: notifire.getMainText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildChangeableButton(
                            active: true,
                            selected: false,
                            title: "Nie, wróć",
                            function: () {
                              Get.back();
                            },
                            icon: Icons.arrow_back_outlined,
                            colorOff: appLightGreyColor,
                            colorOn: appGreenColor,
                            sizeIcon: 20),
                        const SizedBox(
                          width: 6,
                        ),
                        _buildChangeableButton(
                            active: true,
                            selected: true,
                            title: "Tak, usuń",
                            function: () {
                              setState(() {
                                polygon.vertices.clear();
                              });
                              Get.back();
                            },
                            icon: Icons.clear_all_outlined,
                            colorOff: appLightGreyColor,
                            colorOn: appRedColor,
                            sizeIcon: 20),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
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
              if (_ctrlRoomName
                      .every((element) => element.value.text.isNotEmpty) &&
                  polygonList.every((element) => element.vertices.length > 3) &&
                  (_ctrlRoomLevel.length == 1 ||
                      _ctrlRoomLevel
                          .every((element) => element.value.text.isNotEmpty))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('JEST OK.'),
                    backgroundColor: Colors.green,
                  ),
                );
                List rommsData = [];
                for (int i = 0; i < roomsQuantityData; i++) {
                  List<Map<String, double>> offsetsMapList =
                      polygonList[i].vertices.map((offset) {
                    return {'dx': offset.dx, 'dy': offset.dy};
                  }).toList();
                  rommsData.add({
                    'offsets': offsetsMapList,
                    'roomName': _ctrlRoomName[i].value.text,
                    'roomLevel': int.parse(_ctrlRoomLevel[i].value.text),
                  });
                }
                await orgRef.set({
                  'processData': {
                    'creationStatus': {
                      'status': 'inProgress',
                      'step': 2,
                    }
                  },
                  'projectData': {
                    'rooms': rommsData,
                  }
                }, SetOptions(merge: true));
              } else {
                if (!polygonList
                    .every((element) => element.vertices.length > 3)) {
                  List tempList = [];
                  for (int i = 0; i < polygonList.length; i++) {
                    var element = polygonList[i];
                    if (!(element.vertices.length > 3)) {
                      tempList.add(i + 1);
                    }
                  }
                  String text1 =
                      'Każda sala musi posiadać co najmniej 4 punkty, aby projekt mógł zostać zatwierdzony.';
                  String text21 = 'Problem wykryto w sali nr:';
                  String text22 = 'Problemy wykryto w salach nr:';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 8),
                      content: Text(
                          "$text1 ${tempList.length > 1 ? text22 : text21} ${tempList.join(', ')}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (!_ctrlRoomName
                    .every((element) => element.value.text.isNotEmpty)) {
                  List tempList = [];
                  for (int i = 0; i < _ctrlRoomName.length; i++) {
                    var element = _ctrlRoomName[i];
                    if (!(element.value.text.isNotEmpty)) {
                      tempList.add(i + 1);
                    }
                  }
                  String text1 =
                      'Każda sala musi posiadać zdefiniowaną nazwę, aby projekt mógł zostać zatwierdzony.';
                  String text21 = 'Problem wykryto w sali nr:';
                  String text22 = 'Problemy wykryto w salach nr:';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 8),
                      content: Text(
                          "$text1 ${tempList.length > 1 ? text22 : text21} ${tempList.join(', ')}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (!_ctrlRoomLevel
                    .every((element) => element.value.text.isNotEmpty)) {
                  List tempList = [];
                  for (int i = 0; i < _ctrlRoomLevel.length; i++) {
                    var element = _ctrlRoomLevel[i];
                    if (!(element.value.text.isNotEmpty)) {
                      tempList.add(i + 1);
                    }
                  }
                  String text1 =
                      'Każda sala musi posiadać zdefiniowany poziom, aby projekt mógł zostać zatwierdzony.';
                  String text21 = 'Problem wykryto w sali nr:';
                  String text22 = 'Problemy wykryto w salach nr:';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 8),
                      content: Text(
                          "$text1 ${tempList.length > 1 ? text22 : text21} ${tempList.join(', ')}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Upps... Coś poszło nie tak. Spróbuj ponownie.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
              controller.changePage(4);
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
                    // ignore: deprecated_member_use
                    color: Colors.white,
                  )),
                ),
              ],
            )),
      ),
    );
  }

  Widget drawMenuRight(Polygon polygon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: polygon.vertices.length > 3
                ? 'Dorysuj figurę i zakończ rysowanie'
                : 'Za mało punktów, aby zakończyć',
            child: _buildChangeableButton(
                active: polygon.vertices.length > 3 &&
                    !(polygon.vertices.first.dx == polygon.vertices.last.dx ||
                        polygon.vertices.first.dy == polygon.vertices.last.dy),
                selected: true,
                title: "Dorysuj",
                function: () {
                  setState(() {
                    endDraw(polygon);
                  });
                },
                icon: Icons.draw_outlined,
                colorOff: notifire.getcontiner,
                colorOn: appGreenColor,
                sizeIcon: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: polygon.vertices.isNotEmpty
                ? 'Cofnij ostatnią czynność'
                : 'Brak czynności możliwych do cofnięcia',
            child: _buildChangeableButton(
                active: polygon.vertices.isNotEmpty,
                selected: true,
                title: "Cofnij",
                function: () {
                  setState(() {
                    polygon.vertices.isNotEmpty
                        ? polygon.vertices.length == 2
                            ? polygon.vertices.clear()
                            : polygon.vertices.remove(polygon.vertices.last)
                        : null;
                  });
                },
                icon: Icons.arrow_back_outlined,
                colorOff: notifire.getcontiner,
                colorOn: appOrangeColor,
                sizeIcon: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: polygon.vertices.isNotEmpty
                ? 'Wyczyść wszystko i zacznij od nowa'
                : 'Brak czyności możliwych do wyczyszczenia',
            child: _buildChangeableButton(
                active: polygon.vertices.isNotEmpty,
                selected: true,
                title: "Wyczyść",
                function: () {
                  _buildDialogDeleteAll(polygonList[_tabCtrlRoom.index]);
                },
                icon: Icons.clear_all_outlined,
                colorOff: notifire.getcontiner,
                colorOn: appRedColor,
                sizeIcon: 20),
          ),
        ),
      ],
    );
  }

  Widget drawMenuLeft() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: 'Rysuj pod kątem prostym',
            child: _buildChangeableButton(
                active: true,
                selected: rightAngleMode,
                title: "Kąt prosty",
                function: () {
                  setState(() {
                    rightAngleMode = !rightAngleMode;
                  });
                },
                icon: Icons.square_foot_outlined,
                colorOff: notifire.getcontiner,
                colorOn: appPurpleColor,
                sizeIcon: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: 'Włącz / wyłącz siatkę pomocniczą',
            child: _buildChangeableButton(
                active: true,
                selected: gridMode,
                title: "Siatka",
                function: () {
                  setState(() {
                    gridMode = !gridMode;
                  });
                },
                icon: Icons.grid_4x4_outlined,
                colorOff: notifire.getcontiner,
                colorOn: appPurpleColor,
                sizeIcon: 20),
          ),
        ),
        Visibility(
          visible: gridMode,
          child: Tooltip(
            showDuration: const Duration(milliseconds: 200),
            waitDuration: const Duration(milliseconds: 400),
            message: "Wybierz gęstość siatki pomocniczej",
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                height: 45,
                width: 160,
                // padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: appPurpleColor),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: notifire.getGridPaperColor,
                ),
                child: DropdownButton(
                  alignment: AlignmentDirectional.center,
                  value: gridSettings,
                  dropdownColor: notifire.getGridPaperColor,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  elevation: 0,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black),
                  items: gridType.map((String items) {
                    return DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: items,
                      child: SizedBox(width: 100, child: Text(items)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gridSettings = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  endDraw(Polygon draw) {
    if (draw.vertices.length > 3) {
      // first quarter
      if (draw.vertices.first.dx > 0 && draw.vertices.first.dy < 0) {
        if (draw.vertices[1].dy > draw.vertices.first.dy) {
          draw.vertices
              .add(Offset(draw.vertices.last.dx, draw.vertices.first.dy));
        } else {
          draw.vertices
              .add(Offset(draw.vertices.first.dx, draw.vertices.last.dy));
        }
        // second quarter
      } else if (draw.vertices.first.dx < 0 && draw.vertices.first.dy < 0) {
        if (draw.vertices[1].dy > draw.vertices.first.dy) {
          draw.vertices
              .add(Offset(draw.vertices.last.dx, draw.vertices.first.dy));
        } else {
          draw.vertices
              .add(Offset(draw.vertices.first.dx, draw.vertices.last.dy));
        }
        // third quarter
      } else if (draw.vertices.first.dx < 0 && draw.vertices.first.dy > 0) {
        if (draw.vertices[1].dy < draw.vertices.first.dy) {
          draw.vertices
              .add(Offset(draw.vertices.last.dx, draw.vertices.first.dy));
        } else {
          draw.vertices
              .add(Offset(draw.vertices.first.dx, draw.vertices.last.dy));
        }
        // fourth quarter
      } else if (draw.vertices.first.dx > 0 && draw.vertices.first.dy > 0) {
        if (draw.vertices[1].dy < draw.vertices.first.dy) {
          draw.vertices
              .add(Offset(draw.vertices.last.dx, draw.vertices.first.dy));
        } else {
          draw.vertices
              .add(Offset(draw.vertices.first.dx, draw.vertices.last.dy));
        }
      } else {}
    }
  }

  drawMode(bool mode, Polygon draw, double offX, double offY) {
    setState(() {
      //right angle mode ON
      if (draw.vertices.isNotEmpty && mode) {
        if ((offX - draw.vertices.last.dx).abs() >
            (offY - draw.vertices.last.dy).abs()) {
          draw.vertices.add(Offset(offX, draw.vertices.last.dy));
        } else {
          draw.vertices.add(Offset(draw.vertices.last.dx, offY));
        }
        //right angle mode OFF
      } else {
        draw.vertices.add(Offset(offX, offY));
      }
    });
  }

  Widget _buildChangeableButton(
      {required String title,
      required Color colorOn,
      required Color colorOff,
      required double sizeIcon,
      required IconData icon,
      required VoidCallback? function,
      required bool active,
      required bool selected}) {
    return ElevatedButton(
        onPressed: active ? function : null,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(160, 45),
            elevation: 0,
            side: BorderSide(
                width: 1, color: !selected ? colorOn : Colors.transparent),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            backgroundColor: selected ? colorOn : colorOff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: !active
                  ? notifire.getMainText
                  : selected
                      ? Colors.white
                      : notifire.getMainText,
              size: sizeIcon,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: !active
                      ? notifire.getMainText
                      : selected
                          ? Colors.white
                          : notifire.getMainText),
            ),
          ],
        ));
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

  Widget buildTextFieldNameAndLevels(
      {required String hinttext,
      required IconData icon,
      required TextEditingController controller,
      TextEditingController? levelController,
      required double width,
      required int levelsAmount}) {
    return Center(
      child: SizedBox(
        width: width,
        child: Form(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę uzupełnij to pole';
                    }
                    return null;
                  },
                  style: mediumBlackTextStyle.copyWith(
                      color: notifire.getMainText),
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: notifire.getMainText,
                        ),
                        borderRadius: BorderRadius.circular(25)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: hinttext,
                    hintStyle: mediumGreyTextStyle,
                    prefixIcon: SizedBox(
                      height: 20,
                      width: 50,
                      child: Center(
                          child: Icon(
                        icon,
                        size: 18,
                        color: notifire.getMainText,
                      )),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: levelsAmount > 1,
                child: Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Uzupełnij to pole';
                        } else if (levelsAmount > 1 &&
                            (int.parse(value) > levelsAmount)) {
                          return 'Max. $levelsAmount';
                        } else if (levelsAmount > 1 && (int.parse(value) < 0)) {
                          return 'Min. 0';
                        }
                        return null;
                      },
                      textAlign: TextAlign.center,
                      style: mediumBlackTextStyle.copyWith(
                          color: notifire.getMainText),
                      controller: levelController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: notifire.getMainText,
                            ),
                            borderRadius: BorderRadius.circular(25)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: 'Nr poziomu',
                        hintStyle: mediumGreyTextStyle,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
