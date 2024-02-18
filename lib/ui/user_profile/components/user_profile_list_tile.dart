import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class UserProfileListTile extends StatefulWidget {
  final String title;
  final String icon;
  final String subtitle;
  const UserProfileListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.subtitle});

  @override
  State<UserProfileListTile> createState() => _UserProfileListTileState();
}

class _UserProfileListTileState extends State<UserProfileListTile>
    with SingleTickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(widget.icon,
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(appGreyColor, BlendMode.srcIn)),
        const SizedBox(
          width: 8,
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(text: widget.title, style: mediumGreyTextStyle),
          TextSpan(
              text: widget.subtitle,
              style:
                  mediumBlackTextStyle.copyWith(color: notifire.getMainText)),
        ]))
      ],
    );
  }
}
