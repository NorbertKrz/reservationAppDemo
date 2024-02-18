import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class BookingInfoPercentage extends StatefulWidget {
  final double percentage;
  final String mainText;
  final String additionalText;
  final String bottomText;
  final Color color;
  const BookingInfoPercentage({
    super.key,
    required this.percentage,
    required this.mainText,
    required this.additionalText,
    required this.bottomText,
    required this.color,
  });

  @override
  State<BookingInfoPercentage> createState() => _BookingInfoPercentageState();
}

class _BookingInfoPercentageState extends State<BookingInfoPercentage> {
  late DocumentReference orgRef;

  List card2name = [
    "Zrealizowano dziś",
    "Total Sale",
    "Zrealizowano w tym miesiącu",
    "Total Order",
  ];

  List card2price = [
    "\$1,222",
    "\$4,451",
    "\$7,136",
    "\$9,233",
  ];

  List card2pr = [
    "12%",
    "20.2%",
    "15.6%",
    "39.3%",
  ];

  List card2value = [
    0.3,
    0.6,
    0.9,
    0.2,
  ];
  List card2price1 = [
    "\$9,233",
    "\$7,136",
    "\$1,222",
    "\$4,451",
  ];

  List cardcolors = [
    const Color(0xff1a7cbc),
    const Color(0xfff07521),
    const Color(0xff4caf50),
    const Color(0xff18a0fb),
  ];

  List<Booking> bookingListFinish = [];
  List<Booking> bookingListAll = [];
  int bookingsFinishToday = 0;
  int bookingsFinishMonth = 0;
  int bookingsToday = 0;
  int bookingsMonth = 0;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire!.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.mainText,
                      style: mediumBlackTextStyle.copyWith(
                          color: notifire!.getMainText)),
                  const Spacer(),
                  SvgPicture.asset(
                    "assets/more-vertical.svg",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        notifire!.getMainText, BlendMode.srcIn),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    widget.additionalText,
                    style:
                        mainTextStyle.copyWith(color: notifire!.getTextColor1),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "${(widget.percentage * 100).toStringAsFixed(0)}%",
                    style: mediumBlackTextStyle.copyWith(color: widget.color),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: widget.percentage,
                    valueColor: AlwaysStoppedAnimation(widget.color),
                    backgroundColor: widget.color.withOpacity(0.1),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Do zrealizowania pozostało: ",
                    style: mediumGreyTextStyle),
                TextSpan(
                    text: widget.bottomText,
                    style: mediumBlackTextStyle.copyWith(color: widget.color)),
              ]))
            ]),
      ),
    );
  }
}
