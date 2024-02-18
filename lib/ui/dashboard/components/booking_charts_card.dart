import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';
import 'package:reservation_app/ui/dashboard/components/chart/booking_info_percentage.dart';
import 'package:reservation_app/ui/dashboard/components/chart/booking_year_chart.dart';
import 'package:reservation_app/ui/dashboard/components/chart/booking_week_chart.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class BookingChartsCard extends StatefulWidget {
  final int count;
  const BookingChartsCard({
    super.key,
    required this.count,
  });

  @override
  State<BookingChartsCard> createState() => _BookingChartsCardState();
}

class _BookingChartsCardState extends State<BookingChartsCard> {
  late DocumentReference orgRef;

  List<Booking> bookingListFinish = [];
  List<Booking> bookingListAll = [];
  int bookingsFinishToday = 0;
  int bookingsFinishMonth = 0;
  int bookingsToday = 0;
  int bookingsMonth = 0;
  double percentageToday = 0;
  double percentageMonth = 0;

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
              bookingListAll = orgData.reservations;
              bookingListFinish = orgData.reservations
                  .where((element) =>
                      element.bookingTime.toDate().isBefore(DateTime.now()))
                  .toList();
              bookingsToday = bookingListAll
                  .where((element) =>
                      element.bookingTime.toDate().day == DateTime.now().day)
                  .length;
              bookingsMonth = bookingListAll
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .length;
              bookingsFinishMonth = bookingListFinish
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .length;
              bookingsFinishToday = bookingListFinish
                  .where((element) =>
                      element.bookingTime.toDate().day == DateTime.now().day)
                  .length;
              percentageToday =
                  bookingsToday != 0 ? bookingsFinishToday / bookingsToday : 0;
              percentageMonth =
                  bookingsMonth != 0 ? bookingsFinishMonth / bookingsMonth : 0;
            }
            return GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.count, mainAxisExtent: 200),
              itemBuilder: (context, index) {
                return index == 0
                    ? BookingInfoPercentage(
                        percentage: percentageToday,
                        mainText: 'Dziś zrealizowano',
                        additionalText: '$bookingsFinishToday rezerwacji',
                        color: const Color(0xff1a7cbc),
                        bottomText:
                            "${bookingsToday - bookingsFinishToday} rezerwacji",
                      )
                    : index == 1
                        ? const BookingWeekChart()
                        : index == 2
                            ? BookingInfoPercentage(
                                percentage: percentageMonth,
                                mainText: 'W tym miesiącu zrealizowano',
                                additionalText:
                                    '$bookingsFinishMonth rezerwacji',
                                color: const Color(0xfff07521),
                                bottomText:
                                    "${bookingsMonth - bookingsFinishMonth} rezerwacji",
                              )
                            : const BookingYearChart();
              },
            );
          },
        );
      },
    );
  }
}
