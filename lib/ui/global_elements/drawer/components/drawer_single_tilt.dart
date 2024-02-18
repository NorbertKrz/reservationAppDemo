import 'package:flutter_svg/svg.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerSingleTilt extends StatefulWidget {
  final String header;
  final String iconpath;
  final int index;
  final void Function() ontap;
  const DrawerSingleTilt(
      {Key? key,
      required this.header,
      required this.iconpath,
      required this.index,
      required this.ontap})
      : super(key: key);

  @override
  State<DrawerSingleTilt> createState() => _DrawerSingleTiltState();
}

class _DrawerSingleTiltState extends State<DrawerSingleTilt> {
  AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());
  final screenwidth = Get.width;
  bool ispresent = false;
  static const breakpoint = 800.0;

  @override
  Widget build(BuildContext context) {
    if (screenwidth >= breakpoint) {
      setState(() {
        ispresent = true;
      });
    }
    return Obx(() => ListTileTheme(
          horizontalTitleGap: 12.0,
          dense: true,
          child: ListTile(
            hoverColor: Colors.transparent,
            onTap: widget.ontap,
            title: Text(
              widget.header,
              style: mediumBlackTextStyle.copyWith(
                  fontSize: 14,
                  color: controller.pageselecter.value == widget.index
                      ? appMainColor
                      : notifire!.getMainText),
            ),
            leading: SvgPicture.asset(
              widget.iconpath,
              height: 18,
              width: 18,
              colorFilter: ColorFilter.mode(
                  controller.pageselecter.value == widget.index
                      ? appMainColor
                      : notifire!.getMainText,
                  BlendMode.srcIn),
            ),
            trailing: const SizedBox(),
            contentPadding: EdgeInsets.symmetric(
                vertical: ispresent ? 5 : 2, horizontal: 8),
          ),
        ));
  }
}
