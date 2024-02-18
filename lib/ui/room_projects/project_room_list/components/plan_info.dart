import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';

class PlanInfo extends StatefulWidget {
  const PlanInfo({Key? key}) : super(key: key);

  @override
  State<PlanInfo> createState() => _PlanInfoState();
}

class _PlanInfoState extends State<PlanInfo> {
  final AppConst controller = Get.put(AppConst());
  Plan plan = Plan.basic;
  Timestamp expirationDate = Timestamp(0, 0);
  Timestamp createdTime = Timestamp(0, 0);

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, value, child) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is AuthStateLoggedIn) {
              plan = state.user.accountData!.plan;
              expirationDate = state.user.accountData!.expirationDate;
              createdTime = state.user.accountData!.createdTime;
            }
            return Padding(
              padding: const EdgeInsets.all(padding),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: notifire!.getcontiner,
                  boxShadow: boxShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Twój plan",
                              style: mainTextStyle.copyWith(
                                  fontSize: 17, color: notifire!.getMainText)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                  "Twój plan: ${plan == Plan.basic ? 'Podstawowy' : plan == Plan.standard ? 'Standard' : 'Pro'}"),
                              Text(
                                  "Data wygaśnięcia: ${formatDate(expirationDate.toDate(), [
                                    dd,
                                    '.',
                                    mm,
                                    '.',
                                    yyyy
                                  ])}"),
                            ],
                          ),
                        )
                      ],
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
