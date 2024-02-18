import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';
import 'package:reservation_app/ui/dashboard/components/booking_charts_card.dart';
import 'package:reservation_app/ui/dashboard/components/booking_info_card.dart';
import 'package:reservation_app/ui/dashboard/components/mobile_version_card.dart';
import 'package:reservation_app/ui/dashboard/components/tasks_to_do_list.dart';
import 'package:reservation_app/ui/dashboard/components/upcoming_booking_card.dart';
import 'package:reservation_app/ui/global_elements/bottom_bar/bottom_bar.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/global_elements/widgets/sizebox.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _NewDefaultPage();
}

class _NewDefaultPage extends State<DashboardScreen> {
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolder = TextEditingController();
  TextEditingController cardCvc = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    cardNumber.dispose();
    cardHolder.dispose();
    cardCvc.dispose();
  }

  ColorProvider notifire = ColorProvider();
  late DocumentReference orgRef;
  List<Booking> bookingListFinish = [];
  List<Booking> bookingListAll = [];
  String earliestBookingTime = '';
  int earliestBookingTable = 0;
  int earliestBookingNumberPerson = 0;
  int bookingsToday = 0;
  int bookingsMonth = 0;
  int personMonth = 0;
  int bookingsFinishToday = 0;
  int bookingsFinishMonth = 0;
  int personFinishMonth = 0;

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
            personMonth = 0;
            personFinishMonth = 0;
            if (state is OrganizationPobrane) {
              OrganizationModel orgData = state.organization
                  .firstWhere((element) => element.ref == orgRef);
              bookingListAll = orgData.reservations;
              bookingListFinish = orgData.reservations
                  .where((element) =>
                      element.bookingTime.toDate().isBefore(DateTime.now()))
                  .toList();
              bookingListAll
                  .sort((a, b) => a.bookingTime.compareTo(b.bookingTime));
              bookingListFinish
                  .sort((a, b) => a.bookingTime.compareTo(b.bookingTime));
              earliestBookingTime =
                  '${bookingListAll.first.bookingTime.toDate().hour}:${bookingListAll.first.bookingTime.toDate().minute}';
              earliestBookingTable = bookingListAll.first.tableNo.toInt();
              earliestBookingNumberPerson =
                  bookingListAll.first.peopleNumber.toInt();
              bookingsToday = bookingListAll
                  .where((element) =>
                      element.bookingTime.toDate().day == DateTime.now().day)
                  .length;
              bookingsMonth = bookingListAll
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .length;
              bookingListAll
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .forEach((element) {
                personMonth = personMonth + element.peopleNumber.toInt();
              });
              bookingsFinishToday = bookingListFinish
                  .where((element) =>
                      element.bookingTime.toDate().day == DateTime.now().day)
                  .length;
              bookingsFinishMonth = bookingListFinish
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .length;
              bookingListFinish
                  .where((element) =>
                      element.bookingTime.toDate().month ==
                      DateTime.now().month)
                  .forEach((element) {
                personFinishMonth =
                    personFinishMonth + element.peopleNumber.toInt();
              });
            }
            return DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: notifire.getbgcolor,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const PathViewTitle(
                                title: 'Główna', path: "Dashboard"),
                            BookingInfoCard(
                              title: "Nadchodząca rezerwacja",
                              iconpath: "svg/clock_soon.svg",
                              mainText: bookingListAll.isNotEmpty
                                  ? earliestBookingTime
                                  : 'Brak danych',
                              additionalText:
                                  "Stolik nr $earliestBookingTable (osób: $earliestBookingNumberPerson)",
                              maincolor: const Color(0xFF448AFF),
                            ),
                            BookingInfoCard(
                              title: 'Liczba rezerwacji dziś',
                              iconpath: "svg/clock.svg",
                              mainText: bookingsToday.toString(),
                              additionalText:
                                  "Zrealizowano: $bookingsFinishToday",
                              maincolor: Colors.pinkAccent,
                            ),
                            BookingInfoCard(
                              title: "Liczba rezerwacji w tym miesiącu",
                              iconpath: "svg/calendar_fill.svg",
                              mainText: bookingsMonth.toString(),
                              additionalText:
                                  "Zrealizowano: $bookingsFinishMonth",
                              maincolor: Colors.deepOrangeAccent,
                            ),
                            BookingInfoCard(
                              title: "Zadeklarowanych osób w miesiącu",
                              iconpath: "assets/users33.svg",
                              mainText: personMonth.toString(),
                              additionalText: "Obsłużono: $personFinishMonth",
                              maincolor: Colors.deepPurpleAccent,
                            ),
                            const UpcomingBookingCard(),
                            MobileVersionCard(width: constraints.maxWidth),
                            const TasksToDoList(),
                            const BookingChartsCard(count: 1),
                            const SizeBoxx(),
                            const BottomBar(),
                          ],
                        ),
                      );
                    } else if (constraints.maxWidth < 1000) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const PathViewTitle(
                                title: 'Default', path: "Dashboards"),
                            Row(
                              children: [
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Nadchodząca rezerwacja",
                                    iconpath: "svg/clock_soon.svg",
                                    mainText: bookingListAll.isNotEmpty
                                        ? earliestBookingTime
                                        : 'Brak danych',
                                    additionalText:
                                        "Stolik nr $earliestBookingTable (osób: $earliestBookingNumberPerson)",
                                    maincolor: const Color(0xFF448AFF),
                                  ),
                                ),
                                Expanded(
                                  child: BookingInfoCard(
                                    title: 'Liczba rezerwacji dziś',
                                    iconpath: "svg/clock.svg",
                                    mainText: bookingsToday.toString(),
                                    additionalText:
                                        "Zrealizowano: $bookingsFinishToday",
                                    maincolor: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Liczba rezerwacji w tym miesiącu",
                                    iconpath: "svg/calendar_fill.svg",
                                    mainText: bookingsMonth.toString(),
                                    additionalText:
                                        "Zrealizowano: $bookingsFinishMonth",
                                    maincolor: Colors.deepOrangeAccent,
                                  ),
                                ),
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Zadeklarowanych osób w miesiącu",
                                    iconpath: "assets/users33.svg",
                                    mainText: personMonth.toString(),
                                    additionalText:
                                        "Obsłużono: $personFinishMonth",
                                    maincolor: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Expanded(child: UpcomingBookingCard()),
                                Expanded(child: TasksToDoList()),
                              ],
                            ),
                            MobileVersionCard(width: constraints.maxWidth),
                            const Row(
                              children: [
                                Expanded(child: BookingChartsCard(count: 2)),
                              ],
                            ),
                            const SizeBoxx(),
                            const BottomBar(),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const PathViewTitle(
                                title: 'Główna', path: "Dashboard"),
                            Row(
                              children: [
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Nadchodząca rezerwacja",
                                    iconpath: "svg/clock_soon.svg",
                                    mainText: bookingListAll.isNotEmpty
                                        ? earliestBookingTime
                                        : 'Brak danych',
                                    additionalText:
                                        "Stolik nr $earliestBookingTable (osób: $earliestBookingNumberPerson)",
                                    maincolor: const Color(0xFF448AFF),
                                  ),
                                ),
                                Expanded(
                                  child: BookingInfoCard(
                                    title: 'Liczba rezerwacji dziś',
                                    iconpath: "svg/clock.svg",
                                    mainText: bookingsToday.toString(),
                                    additionalText:
                                        "Zrealizowano: $bookingsFinishToday",
                                    maincolor: Colors.pinkAccent,
                                  ),
                                ),
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Liczba rezerwacji w tym miesiącu",
                                    iconpath: "svg/calendar_fill.svg",
                                    mainText: bookingsMonth.toString(),
                                    additionalText:
                                        "Zrealizowano: $bookingsFinishMonth",
                                    maincolor: Colors.deepOrangeAccent,
                                  ),
                                ),
                                Expanded(
                                  child: BookingInfoCard(
                                    title: "Zadeklarowanych osób w miesiącu",
                                    iconpath: "assets/users33.svg",
                                    mainText: personMonth.toString(),
                                    additionalText:
                                        "Obsłużono: $personFinishMonth",
                                    maincolor: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: UpcomingBookingCard(),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: MobileVersionCard(
                                      width: constraints.maxWidth),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: TasksToDoList(),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Expanded(child: BookingChartsCard(count: 4)),
                              ],
                            ),
                            const SizeBoxx(),
                            const BottomBar(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
