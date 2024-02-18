import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/decode_functions/plan_decoder_fnc.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_list_tile.dart';

class UserProfilePlan extends StatefulWidget {
  final bool isMobile;
  const UserProfilePlan({super.key, required this.isMobile});

  @override
  State<UserProfilePlan> createState() => _UserProfilePlanState();
}

class _UserProfilePlanState extends State<UserProfilePlan>
    with SingleTickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  Plan plan = Plan.basic;
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
          plan = state.user.accountData!.plan;
          expirationDate = state.user.accountData!.expirationDate;
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Container(
                      // height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(widget.isMobile ? 10 : padding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.isMobile ? 10 : padding),
                                child: Text(
                                  "Dane dotyczące Twojego planu",
                                  style: mediumGreyTextStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.isMobile ? 10 : padding),
                                child: Column(
                                  children: [
                                    UserProfileListTile(
                                        title: "Nazwa: ",
                                        icon: "assets/home.svg",
                                        subtitle: planDecoderFnc(plan)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    UserProfileListTile(
                                        title: "Czas ważności: ",
                                        icon: "svg/calendar.svg",
                                        subtitle:
                                            "${expirationDate.toDate().day.toString()}.${expirationDate.toDate().month.toString()}.${expirationDate.toDate().year.toString()}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      ),
                    )
                  ]),
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
  }
}
