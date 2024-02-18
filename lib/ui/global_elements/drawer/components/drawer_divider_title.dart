import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerDividerTitle extends StatefulWidget {
  final String title;
  const DrawerDividerTitle({Key? key, required this.title}) : super(key: key);

  @override
  State<DrawerDividerTitle> createState() => _DrawerDividerTitleState();
}

class _DrawerDividerTitleState extends State<DrawerDividerTitle> {
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
    return GetBuilder<AppConst>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: ispresent ? 15 : 10,
              width: ispresent ? 230 : 260,
              child: Center(
                  child: Divider(color: notifire!.getbordercolor, height: 1))),
          SizedBox(
            height: ispresent ? 15 : 10,
          ),
          Text(
            widget.title,
            style: mainTextStyle.copyWith(
                fontSize: 14, color: notifire!.getMainText),
          ),
          SizedBox(
            height: ispresent ? 10 : 8,
          ),
        ],
      );
    });
  }
}
