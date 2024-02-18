import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_style_data/styles.dart';
import '../../provider/color_provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              boxShadow: boxShadow, color: notifire!.getPrimeryColor),
          child: Center(
              child: Text(
            "Copyright 2023 © Zarezerwuj stolik",
            style: TextStyle(color: notifire!.getMainText),
          )),
        );
      },
    );
  }
}
