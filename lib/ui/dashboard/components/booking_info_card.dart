import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';

class BookingInfoCard extends StatefulWidget {
  final String title;
  final String iconpath;
  final String mainText;
  final String additionalText;
  final Color maincolor;
  const BookingInfoCard(
      {super.key,
      required this.title,
      required this.iconpath,
      required this.mainText,
      required this.additionalText,
      required this.maincolor});

  @override
  State<BookingInfoCard> createState() => _BookingInfoCardState();
}

class _BookingInfoCardState extends State<BookingInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire!.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              dense: true,
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.maincolor.withOpacity(0.2),
                ),
                child: Center(
                    child: SvgPicture.asset(
                  colorFilter:
                      ColorFilter.mode(widget.maincolor, BlendMode.srcIn),
                  widget.iconpath,
                  height: 25,
                  width: 25,
                )),
              ),
              title: Text(
                widget.title,
                style: mediumGreyTextStyle,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.mainText,
                      style:
                          mainTextStyle.copyWith(color: notifire!.getMainText),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(widget.additionalText,
                            style: mediumGreyTextStyle,
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
