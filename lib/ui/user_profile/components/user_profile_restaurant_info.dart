import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/tools/decode_functions/role_decoder_fnc.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_list_tile.dart';

class UserProfileRestaurantInfo extends StatefulWidget {
  final int count;
  final bool isphon;
  const UserProfileRestaurantInfo(
      {super.key, required this.count, required this.isphon});

  @override
  State<UserProfileRestaurantInfo> createState() =>
      _UserProfileRestaurantInfoState();
}

class _UserProfileRestaurantInfoState extends State<UserProfileRestaurantInfo>
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
    return BlocBuilder<UserBloc, UserState>(
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
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // height: 200,
                        padding: EdgeInsets.all(widget.isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("1",
                                          style: mediumBlackTextStyle.copyWith(
                                              fontSize: 16,
                                              color: notifire.getMainText)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Restauracje",
                                          style: mediumGreyTextStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height: 20,
                                    child: VerticalDivider(
                                        color: Colors.grey, width: 50)),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("2",
                                          style: mediumBlackTextStyle.copyWith(
                                              fontSize: 16,
                                              color: notifire.getMainText)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Sale",
                                          style: mediumGreyTextStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height: 20,
                                    child: VerticalDivider(
                                        color: Colors.grey, width: 50)),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("7",
                                          style: mediumBlackTextStyle.copyWith(
                                              fontSize: 16,
                                              color: notifire.getMainText)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Pracownicy",
                                          style: mediumGreyTextStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.isphon ? 10 : padding),
                              child: Column(
                                children: [
                                  UserProfileListTile(
                                      title: "Nazwa: ",
                                      icon: "assets/home.svg",
                                      subtitle: restaurantName),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  UserProfileListTile(
                                      title: "Adres: ",
                                      icon: "assets/location-pin.svg",
                                      subtitle:
                                          "$city, ul. $restaurantAddress"),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  UserProfileListTile(
                                      title: "Stanowisko: ",
                                      icon: "assets/briefcase.svg",
                                      subtitle: roleDecoderFnc(role)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
