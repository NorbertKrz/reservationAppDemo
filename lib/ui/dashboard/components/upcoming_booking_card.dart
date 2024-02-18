import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class UpcomingBookingCard extends StatefulWidget {
  const UpcomingBookingCard({
    super.key,
  });

  @override
  State<UpcomingBookingCard> createState() => _UpcomingBookingCardState();
}

class _UpcomingBookingCardState extends State<UpcomingBookingCard> {
  late DocumentReference orgRef;
  List<Booking> bookingList = [];
  List<Booking> bookingSoonList = [];
  List timeIcons = [
    "svg/clock_soon/clock-soon_1.svg",
    "svg/clock_soon/clock-soon_2.svg",
    "svg/clock_soon/clock-soon_3.svg",
    "svg/clock_soon/clock-soon_4.svg",
    "svg/clock_soon/clock-soon_5.svg",
    "svg/clock_soon/clock-soon_6.svg",
  ];
  List<Color> colorList = [
    const Color(0xff0CAF60),
    const Color.fromARGB(255, 60, 180, 122),
    const Color.fromARGB(255, 103, 175, 140),
    const Color.fromARGB(255, 123, 173, 149),
    const Color.fromARGB(255, 133, 180, 158),
    const Color.fromARGB(255, 149, 175, 163),
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          orgRef = state.user.organizationRef!;
        }
        return BlocBuilder<OrganizationBloc, OrganizationState>(
          builder: (context, state) {
            if (state is OrganizationPobrane) {
              OrganizationModel orgData = state.organization
                  .firstWhere((element) => element.ref == orgRef);
              bookingList = orgData.reservations;
              bookingList = bookingList
                  .where((element) =>
                      element.bookingTime.toDate().isAfter(DateTime.now()))
                  .toList();
              bookingList
                  .sort((a, b) => a.bookingTime.compareTo(b.bookingTime));
              bookingSoonList = bookingList.take(6).toList();
            }
            return Padding(
              padding: const EdgeInsets.all(padding),
              child: Container(
                // height: 500,
                padding: const EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: notifire!.getcontiner,
                  boxShadow: boxShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nadchodzące rezerwacje",
                          style: mainTextStyle.copyWith(
                              color: notifire!.getMainText, fontSize: 18),
                        ),
                        const Spacer(),
                        SvgPicture.asset("assets/more-vertical.svg",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                notifire!.getMainText, BlendMode.srcIn)),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookingSoonList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime tempDate = bookingSoonList[index]
                            .bookingTime
                            .toDate()
                            .toLocal();
                        String time =
                            '${tempDate.hour}:${tempDate.minute}:${tempDate.second}';
                        String date =
                            '${tempDate.day}:${tempDate.month}:${tempDate.year}';
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(timeIcons[index],
                                    height: 30,
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                        // notifire!.getMainText,
                                        colorList[index],
                                        BlendMode.srcIn)),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(time,
                                      style: mediumGreyTextStyle.copyWith(
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis),
                                  Text(date,
                                      style: mediumGreyTextStyle.copyWith(
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              title: Text(
                                "${bookingSoonList[index].name} ${bookingSoonList[index].surname} (stolik: ${bookingSoonList[index].tableNo})",
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.getMainText,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    GestureDetector(
                      onTap: () {
                        //TODO
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Zobacz wszystko",
                            style: mediumGreyTextStyle,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset("assets/angle-right-small.svg",
                              colorFilter: ColorFilter.mode(
                                  notifire!.getMainText, BlendMode.srcIn)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
