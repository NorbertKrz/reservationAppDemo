import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PathViewTitle extends StatefulWidget {
  final String title;
  final String path;
  const PathViewTitle({super.key, required this.title, required this.path});

  @override
  State<PathViewTitle> createState() => _PathViewTitleState();
}

class _PathViewTitleState extends State<PathViewTitle> {
  final AppConst controller = Get.put(AppConst());
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<ColorProvider>(
        builder: (context, value, child) =>
            GetBuilder<AppConst>(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: constraints.maxWidth < 600
                      ? mainTextStyle.copyWith(
                          fontSize: 18, color: notifire!.getMainText)
                      : mainTextStyle.copyWith(color: notifire!.getMainText),
                  overflow: TextOverflow.ellipsis,
                ),
                Flexible(
                  child: Wrap(
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.changePage(0);
                        },
                        child: SvgPicture.asset("assets/home.svg",
                            height: constraints.maxWidth < 600 ? 14 : 16,
                            width: constraints.maxWidth < 600 ? 14 : 16,
                            colorFilter: ColorFilter.mode(
                                notifire!.getMainText, BlendMode.srcIn)),
                      ),
                      Text('   /   ${widget.path}   /   ',
                          style: mediumBlackTextStyle.copyWith(
                              color: notifire!.getMainText,
                              fontSize: constraints.maxWidth < 600 ? 12 : 14),
                          overflow: TextOverflow.ellipsis),
                      Text(widget.title,
                          style: mediumGreyTextStyle.copyWith(
                              color: appMainColor,
                              fontSize: constraints.maxWidth < 600 ? 12 : 14),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      );
    });
  }
}
