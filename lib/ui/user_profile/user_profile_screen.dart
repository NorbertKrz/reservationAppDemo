import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/bottom_bar/bottom_bar.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/global_elements/widgets/sizebox.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_bar.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_data.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_plan.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_restaurant_info.dart';
import '../../business_logic/bloc/user/user_bloc.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  late DocumentReference orgRef;
  String email = '';
  String name = '';
  String surname = '';
  String restaurantName = '';
  String restaurantAddress = '';
  String city = '';
  Plan plan = Plan.basic;
  Role role = Role.viewer;
  Timestamp createdTime = Timestamp(0, 0);
  Timestamp expirationDate = Timestamp(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            email = state.user.email;
            name = state.user.personalData!.name;
            surname = state.user.personalData!.surname;
            plan = state.user.accountData!.plan;
            role = state.user.role!;
            createdTime = state.user.accountData!.createdTime;
            expirationDate = state.user.accountData!.expirationDate;
            orgRef = state.user.organizationRef!;
          }
          return BlocBuilder<OrganizationBloc, OrganizationState>(
            builder: (context, state) {
              if (state is OrganizationPobrane) {
                OrganizationModel orgData = state.organization
                    .firstWhere((element) => element.ref == orgRef);
                city = orgData.general.city;
                restaurantName = orgData.general.name;
                restaurantAddress = orgData.general.streetNumber;
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return NestedScrollView(
                        // physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            const SliverToBoxAdapter(
                              child: PathViewTitle(
                                  title: 'Profil użytkownika',
                                  path: "Użytkownicy"),
                            ),
                            SliverToBoxAdapter(
                              child:
                                  UserProfileBar(width: constraints.maxWidth),
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0,
                                    right: padding,
                                    left: padding,
                                    bottom: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: notifire.getcontiner,
                                    borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(12)),
                                  ),
                                  child: const Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: UserProfileData(
                                                count: 2, isMobile: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child:
                                                UserProfilePlan(isMobile: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                              const SizeBoxx(),
                              const BottomBar(),
                            ],
                          ),
                        ),
                      );
                    } else if (constraints.maxWidth < 1000) {
                      return NestedScrollView(
                        // physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            const SliverToBoxAdapter(
                              child: PathViewTitle(
                                  title: 'Profil użytkownika',
                                  path: "Użytkownicy"),
                            ),
                            SliverToBoxAdapter(
                              child:
                                  UserProfileBar(width: constraints.maxWidth),
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0,
                                    right: padding,
                                    left: padding,
                                    bottom: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: notifire.getcontiner,
                                    borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(12)),
                                  ),
                                  child: const Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: UserProfileData(
                                                count: 4, isMobile: false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: UserProfilePlan(
                                                isMobile: false),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                              const SizeBoxx(),
                              const BottomBar(),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return NestedScrollView(
                        // physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            const SliverToBoxAdapter(
                              child: PathViewTitle(
                                  title: 'Profil użytkownika',
                                  path: "Użytkownicy"),
                            ),
                            SliverToBoxAdapter(
                              child:
                                  UserProfileBar(width: constraints.maxWidth),
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0,
                                  right: padding,
                                  left: padding,
                                  bottom: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: notifire.getcontiner,
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(padding),
                                        child: UserProfileData(
                                            count: 4, isMobile: false),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: UserProfileRestaurantInfo(
                                                count: 4, isphon: false),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: padding,
                                                right: padding,
                                                bottom: padding),
                                            child: UserProfilePlan(
                                                isMobile: false),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizeBoxx(),
                            const BottomBar(),
                          ]),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
