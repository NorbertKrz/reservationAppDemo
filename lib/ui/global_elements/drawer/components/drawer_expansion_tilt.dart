import 'package:flutter_svg/svg.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerExpansionTilt extends StatefulWidget {
  final Widget children;
  final String header;
  final String iconpath;
  final bool visible;
  final int index;
  const DrawerExpansionTilt(
      {Key? key,
      required this.children,
      required this.header,
      required this.iconpath,
      required this.visible,
      required this.index})
      : super(key: key);

  @override
  State<DrawerExpansionTilt> createState() => _DrawerExpansionTiltState();
}

class _DrawerExpansionTiltState extends State<DrawerExpansionTilt> {
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
    return Visibility(
      visible: widget.visible,
      child: ListTileTheme(
        horizontalTitleGap: 12.0,
        dense: true,
        child: ExpansionTile(
          title: Text(
            widget.header,
            style: mediumBlackTextStyle.copyWith(
                fontSize: 14, color: notifire!.getMainText),
          ),
          leading: SvgPicture.asset(widget.iconpath,
              height: 18,
              width: 18,
              colorFilter:
                  ColorFilter.mode(notifire!.getMainText, BlendMode.srcIn)),
          tilePadding:
              EdgeInsets.symmetric(vertical: ispresent ? 5 : 2, horizontal: 8),
          iconColor: appMainColor,
          collapsedIconColor: Colors.grey,
          children: <Widget>[widget.children],
        ),
      ),
    );
  }
}
