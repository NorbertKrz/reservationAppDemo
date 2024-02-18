import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'global_elements/app_bar/app_bar_view.dart';
import 'global_elements/drawer/drawer_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: false);
    RxDouble? screenwidth = Get.width.obs;
    double? breakpoint = 800.0;
    if (screenwidth >= breakpoint) {
      return GetBuilder<AppConst>(builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 260,
                      child: const DarwerView()),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const AppBarView(),
                          Expanded(
                            child: Obx(() {
                              Widget selectedPage = controller
                                  .page[controller.pageselecter.value];
                              return selectedPage;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    } else {
      return GetBuilder<AppConst>(builder: (controller) {
        return Scaffold(
          appBar: const AppBarView(),
          drawer: const Drawer(width: 260, child: DarwerView()),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              Widget selectedPage =
                  controller.page[controller.pageselecter.value];
              return selectedPage;
            }),
          ),
        );
      });
    }
  }
}
