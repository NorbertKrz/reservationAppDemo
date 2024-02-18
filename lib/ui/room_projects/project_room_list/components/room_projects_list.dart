import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';

class RoomProjectsList extends StatefulWidget {
  const RoomProjectsList({Key? key}) : super(key: key);

  @override
  State<RoomProjectsList> createState() => _RoomProjectsListState();
}

class _RoomProjectsListState extends State<RoomProjectsList> {
  final AppConst controller = Get.put(AppConst());

  List<OrganizationModel> projectList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(padding),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: notifire!.getcontiner,
              boxShadow: boxShadow,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Lista projektów",
                      style: mainTextStyle.copyWith(
                          fontSize: 17, color: notifire!.getMainText)),
                ),
                BlocBuilder<OrganizationBloc, OrganizationState>(
                    builder: (context, state) {
                  projectList.clear();
                  if (state is OrganizationPobrane) {
                    for (var element in state.organization) {
                      projectList.add(element);
                    }
                  }
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              'Nazwa',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                                child: Text(
                              'Miasto',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                                child: Text(
                              'Adres',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                                child: Text(
                              'Status',
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: projectList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  if (projectList[index].processInfo.step ==
                                      1) {
                                    controller.changePage(3);
                                    orgRefListener.value =
                                        projectList[index].ref;
                                  } else if (projectList[index]
                                          .processInfo
                                          .step ==
                                      2) {
                                    controller.changePage(4);
                                    orgRefListener.value =
                                        projectList[index].ref;
                                  } else if (projectList[index]
                                          .processInfo
                                          .step ==
                                      3) {
                                    controller.changePage(6);
                                    orgRefListener.value =
                                        projectList[index].ref;
                                  }
                                },
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        projectList[index].general.name,
                                        textAlign: TextAlign.center,
                                      )),
                                      Expanded(
                                          child: Text(
                                        projectList[index].general.city,
                                        textAlign: TextAlign.center,
                                      )),
                                      Expanded(
                                          child: Text(
                                        projectList[index].general.streetNumber,
                                        textAlign: TextAlign.center,
                                      )),
                                      Expanded(
                                        child: statusDecoder(projectList[index]
                                            .processInfo
                                            .status),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget statusDecoder(String status) {
    switch (status) {
      case 'inProgress':
        return const Text(
          'W trakcie',
          textAlign: TextAlign.center,
        );
      case 'done':
        return const Text(
          'Ukończono',
          textAlign: TextAlign.center,
        );
      default:
        return const Text(
          'Brak informacji',
          textAlign: TextAlign.center,
        );
    }
  }
}
