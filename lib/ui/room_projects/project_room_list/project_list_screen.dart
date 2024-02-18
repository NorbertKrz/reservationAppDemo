import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/bottom_bar/bottom_bar.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/global_elements/widgets/sizebox.dart';
import 'package:reservation_app/ui/room_projects/project_room_list/components/plan_info.dart';
import 'package:reservation_app/ui/room_projects/project_room_list/components/room_projects_list.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import '../../provider/color_provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Plan plan;
  Timestamp expirationDate = Timestamp(0, 0);
  Timestamp createdTime = Timestamp(0, 0);
  final AppConst controller = Get.put(AppConst());

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
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: notifire!.getbgcolor,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile layout
                    return const SizedBox(
                      height: 900,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            PathViewTitle(
                                title: 'Lista projektów', path: "Projekt sali"),
                            RoomProjectsList(),
                            PlanInfo(),
                            SizeBoxx(),
                            BottomBar(),
                          ],
                        ),
                      ),
                    );
                  } else if (constraints.maxWidth < 1200) {
                    return const SizedBox(
                      height: 1000,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            PathViewTitle(
                                title: 'Lista projektów', path: "Projekt sali"),
                            RoomProjectsList(),
                            PlanInfo(),
                            SizeBoxx(),
                            BottomBar(),
                          ],
                        ),
                      ),
                    );
                    // Tablet layout
                  } else {
                    // Website layout
                    return const SizedBox(
                      height: 1000,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            PathViewTitle(
                                title: 'Lista projektów', path: "Projekt sali"),
                            Row(
                              children: [
                                Expanded(child: RoomProjectsList()),
                                Expanded(child: PlanInfo()),
                              ],
                            ),
                            SizeBoxx(),
                            BottomBar(),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
