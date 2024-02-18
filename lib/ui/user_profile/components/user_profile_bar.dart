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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class UserProfileBar extends StatefulWidget {
  final double width;
  const UserProfileBar({super.key, required this.width});

  @override
  State<UserProfileBar> createState() => _UserProfileBarState();
}

class _UserProfileBarState extends State<UserProfileBar>
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: notifire.getcontiner),
                            ),
                            const Positioned(
                                left: 20,
                                bottom: -30,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage("images/avatars/man.png"),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.width < 600 ? 10 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$name $surname",
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire.getTextColor1),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            "assets/Frame29.svg",
                            height: 18,
                            width: 18,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        email,
                        style: mediumGreyTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.width < 600 ? 10 : 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset("assets/briefcase.svg",
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                    appGreyColor, BlendMode.srcIn)),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Text(roleDecoderFnc(role),
                                    style: mediumBlackTextStyle.copyWith(
                                        color: appMainColor),
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset("assets/location-pin.svg",
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                    appGreyColor, BlendMode.srcIn)),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Text(
                                    "$restaurantName ($city, ul. $restaurantAddress)",
                                    style: mediumBlackTextStyle.copyWith(
                                        color: appMainColor),
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
