import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/drawer/components/drawer_divider_title.dart';
import 'package:reservation_app/ui/global_elements/drawer/components/drawer_expansion_tilt.dart';
import 'package:reservation_app/ui/global_elements/drawer/components/drawer_single_tilt.dart';
import 'package:reservation_app/ui/global_data/global_variables.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DarwerView extends StatefulWidget {
  const DarwerView({Key? key}) : super(key: key);

  @override
  State<DarwerView> createState() => _DarwerViewState();
}

class _DarwerViewState extends State<DarwerView> {
  AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());

  final screenwidth = Get.width;
  bool ispresent = false;
  Role role = Role.viewer;

  static const breakpoint = 800.0;

  @override
  Widget build(BuildContext context) {
    if (screenwidth >= breakpoint) {
      setState(() {
        ispresent = true;
      });
    }

    return GetBuilder<AppConst>(builder: (controller) {
      return SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is AuthStateLoggedIn) {
              role = state.user.role!;
            }
            return Consumer<ColorProvider>(
              builder: (context, value, child) => Drawer(
                backgroundColor: notifire!.getPrimeryColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: notifire!.getbordercolor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ispresent ? 30 : 15,
                          top: ispresent ? 24 : 20,
                          bottom: ispresent ? 10 : 12),
                      child: InkWell(
                        onTap: () {
                          controller.changePage(0);
                          Get.back();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/applogo.svg",
                              height: 68,
                              width: 68,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const DrawerDividerTitle(title: 'OGÓLNE'),
                                DrawerSingleTilt(
                                    header: "Strona główna",
                                    iconpath: "assets/home.svg",
                                    index: 0,
                                    ontap: () {
                                      controller.changePage(0);
                                      Get.back();
                                    }),
                                const DrawerDividerTitle(title: 'RESTAURACJA'),
                                DrawerSingleTilt(
                                    header: "Widok sal",
                                    iconpath: "assets/octagon-check.svg",
                                    index: 5,
                                    ontap: () {
                                      controller.changePage(5);
                                      Get.back();
                                    }),
                                DrawerExpansionTilt(
                                    visible: role == Role.manager,
                                    index: 0,
                                    header: 'Projekt sali',
                                    iconpath: 'assets/grid-circle.svg',
                                    children: Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              height: ispresent ? 12 : 10,
                                            ),
                                            _subMenuButton(
                                                5, 'Lista projektów'),
                                            _heightSpace(),
                                            _subMenuButton(2, 'Stwórz nowy'),
                                            _heightSpace(),
                                          ],
                                        ),
                                      ],
                                    )),
                                const DrawerDividerTitle(title: 'ZARZĄDZANIE'),
                                DrawerExpansionTilt(
                                    visible: true,
                                    index: 3,
                                    header: 'Pracownicy',
                                    iconpath: 'assets/users.svg',
                                    children: Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              height: ispresent ? 12 : 10,
                                            ),
                                            _subMenuButton(
                                                14, 'Lista pracowników'),
                                            _heightSpace(),
                                            _subMenuButton(15, 'Czas pracy'),
                                            _heightSpace(),
                                          ],
                                        ),
                                      ],
                                    )),
                                DrawerExpansionTilt(
                                    visible: true,
                                    index: 4,
                                    header: 'Lista zadań',
                                    iconpath: 'assets/clipboard-check.svg',
                                    children: Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  height: ispresent ? 12 : 10,
                                                ),
                                                _subMenuButton(
                                                    16, 'Zadania do wykonania'),
                                                _heightSpace(),
                                                _subMenuButton(
                                                    17, 'Zadania wykonane'),
                                                _heightSpace(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                const DrawerDividerTitle(title: 'USTAWIENIA'),
                                DrawerSingleTilt(
                                    header: "Ustawienia",
                                    iconpath: "assets/settings.svg",
                                    index: 55,
                                    ontap: () {
                                      //TODO
                                      controller.changePage(55);
                                      Get.back();
                                    }),
                                const SizedBox(
                                  height: 100,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Wersja: $currentVersion',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _subMenuButton(int index, String text) {
    return InkWell(
        onTap: () {
          controller.changePage(index);
          Get.back();
        },
        child: Row(
          children: [
            _subMenuDash(index: index),
            _subMenuText(title: text, index: index),
          ],
        ));
  }

  Widget _heightSpace() {
    return SizedBox(
      height: ispresent ? 25 : 20,
    );
  }

  Widget _subMenuText({required String title, required int index}) {
    return Obx(
      () => Text(title,
          style: mediumGreyTextStyle.copyWith(
              fontSize: 13,
              color: controller.pageselecter.value == index
                  ? appMainColor
                  : notifire!.getMainText)),
    );
  }

  Widget _subMenuDash({required int index}) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/minus.svg",
              colorFilter: ColorFilter.mode(
                  controller.pageselecter.value == index
                      ? appMainColor
                      : notifire!.getMainText,
                  BlendMode.srcIn),
              width: 6),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }
}
