import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/ui/dashboard/components/chart/chart_week_axis.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';

import '../../../provider/color_provider.dart';

class BookingWeekChart extends StatefulWidget {
  const BookingWeekChart({
    super.key,
  });

  @override
  State<BookingWeekChart> createState() => _BookingWeekChartState();
}

class _BookingWeekChartState extends State<BookingWeekChart> {
  late DocumentReference orgRef;
  List<Timestamp> timestampList = [];
  List<int> weekBookingList = List.generate(7, (index) => 0);
  DateTime actualData = DateTime.now();
  int dayOfWeek = DateTime.now().weekday;
  DateTime startOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endOfWeek =
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));

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
              for (var element in orgData.reservations) {
                timestampList.add(element.bookingTime);
              }

              for (int i = 0; i < 7; i++) {
                DateTime dzien = startOfWeek.add(Duration(days: i));
                int count = 0;
                for (Timestamp timestamp in timestampList) {
                  DateTime dataTimestamp = timestamp.toDate();

                  if (dataTimestamp.year == dzien.year &&
                      dataTimestamp.month == dzien.month &&
                      dataTimestamp.day == dzien.day) {
                    count++;
                  }
                }
                weekBookingList[i] = count;
              }
            }
            return Padding(
              padding: const EdgeInsets.all(padding),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: notifire!.getcontiner,
                  boxShadow: boxShadow,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          Text("Rezerwacje w tym tygodniu",
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
                    ),
                    SizedBox(
                      height: 120,
                      child: ChartAxis(
                        bgcolor: const Color(0xffc7c2ff),
                        bordercolor: const Color(0xff7d70ff),
                        weekBookings: weekBookingList,
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
