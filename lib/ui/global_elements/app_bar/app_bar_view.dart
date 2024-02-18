import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/decode_functions/role_decoder_fnc.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_style_data/routes.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppBarView extends StatefulWidget implements PreferredSizeWidget {
  const AppBarView({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarView> createState() => _AppBarViewState();
}

class _AppBarViewState extends State<AppBarView> {
  bool search = false;
  bool darkMood = false;
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorProvider>(context);
    final screenwidth = Get.width;
    bool ispresent = false;
    String name = 'Anonim';
    Role role = Role.viewer;

    const breakpoint = 600.0;

    if (screenwidth >= breakpoint) {
      setState(() {
        ispresent = true;
      });
    }
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          name = state.user.personalData!.name;
          role = state.user.role!;
        } else {
          name = 'Anonim';
          role = Role.viewer;
        }
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return AppBar(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: notifier.getbordercolor)),
            backgroundColor: notifier.getPrimeryColor,
            elevation: 1,
            leading: ispresent
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: SizedBox(
                        height: 27,
                        width: 27,
                        child: Center(
                            child: SvgPicture.asset(
                          "assets/menu-left.svg",
                          height: 25,
                          width: 25,
                          colorFilter: ColorFilter.mode(
                              notifier.geticoncolor, BlendMode.srcIn),
                        )))),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message: darkMood ? "Tryb jasny" : "Tryb ciemny",
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          darkMood = !darkMood;
                        });

                        if (notifier.isDark == false) {
                          notifier.isavalable(true);
                        } else {
                          notifier.isavalable(false);
                        }
                      },
                      child: SvgPicture.asset(
                        darkMood ? "assets/sun.svg" : "assets/moon.svg",
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            notifier.geticoncolor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  PopupMenuButton(
                    color: notifier.getcontiner,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tooltip: "Powiadomienia",
                    offset: const Offset(0, 50),
                    icon: SvgPicture.asset(
                      "assets/bell-notification.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                          notifier.geticoncolor, BlendMode.srcIn),
                    ),
                    itemBuilder: (ctx) => [
                      //TODO
                    ],
                  ),
                  PopupMenuButton(
                    color: notifier.getcontiner,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tooltip: "Konto",
                    offset: Offset(0, constraints.maxWidth >= 800 ? 60 : 50),
                    child: constraints.maxWidth >= 800
                        ? SizedBox(
                            width: 160,
                            child: ListTile(
                              leading: const CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      AssetImage("images/avatars/man.png"),
                                  backgroundColor: Colors.transparent),
                              title: Text(name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      color: notifier.getMainText)),
                              trailing: null,
                              subtitle: Row(
                                children: [
                                  Text(roleDecoderFnc(role),
                                      style: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: notifier.getMaingey)),
                                  Icon(
                                    Icons.arrow_drop_down_outlined,
                                    size: 12,
                                    color: notifier.geticoncolor,
                                  )
                                ],
                              ),
                            ),
                          )
                        : const CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                AssetImage("images/avatars/man.png"),
                            backgroundColor: Colors.transparent),
                    itemBuilder: (ctx) => [
                      _buildPopupMenuItem(),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  final AppConst controller = Get.put(AppConst());
  PopupMenuItem _buildPopupMenuItem() {
    return PopupMenuItem(
      enabled: false,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 155,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  row(title: 'Profil', icon: 'svg/user.svg', index: 8),
                  row(
                      title: 'Todo',
                      icon: 'assets/clipboard-check.svg',
                      index: 0),
                  row(
                      title: 'Ustawienia',
                      icon: 'assets/settings.svg',
                      index: 0),
                  logoutButton(title: 'Wyloguj', icon: 'assets/log-out.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool light1 = true;

  TableRow row(
      {required String title, required String icon, required int index}) {
    return TableRow(children: [
      TableRowInkWell(
        onTap: () {
          controller.changePage(index);
          Get.back();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(icon,
              width: 18,
              height: 18,
              colorFilter:
                  ColorFilter.mode(notifire!.geticoncolor, BlendMode.srcIn)),
        ),
      ),
      TableRowInkWell(
        onTap: () {
          controller.changePage(index);
          Get.back();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
          child: Text(title,
              style:
                  mediumBlackTextStyle.copyWith(color: notifire!.getMainText)),
        ),
      ),
    ]);
  }

  TableRow logoutButton({required String title, required String icon}) {
    return TableRow(children: [
      TableRowInkWell(
        onTap: () {
          context.read<UserBloc>().add(AuthLogOutEvent());
          Get.offAllNamed(Routes.login);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(icon,
              width: 18,
              height: 18,
              colorFilter:
                  ColorFilter.mode(notifire!.geticoncolor, BlendMode.srcIn)),
        ),
      ),
      TableRowInkWell(
        onTap: () {
          context.read<UserBloc>().add(AuthLogOutEvent());
          Get.back();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
          child: Text(title,
              style:
                  mediumBlackTextStyle.copyWith(color: notifire!.getMainText)),
        ),
      ),
    ]);
  }
}
