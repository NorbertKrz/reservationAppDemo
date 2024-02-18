import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class TasksToDoList extends StatefulWidget {
  const TasksToDoList({
    super.key,
  });

  @override
  State<TasksToDoList> createState() => _TasksToDoListState();
}

class _TasksToDoListState extends State<TasksToDoList> {
  List logo = [
    "svg/cleaning.svg",
    "svg/shopping_cart.svg",
    "svg/box_check.svg",
    "svg/receipt_list.svg",
    "svg/coins.svg",
  ];
  List name = [
    "Sprzątanie dużej sali",
    "Zamówienie zapasów",
    "Dostawa szklanek i talerzy",
    "Podsumowanie miesiąca",
    "Opłaty za lokal",
  ];
  List date = [
    "Wszyscy",
    "Kierownik",
    "Wszyscy",
    "Kierownik",
    "Kierownik",
  ];
  List price = [
    "24/02/2024",
    "25/02/2024",
    "26/02/2024",
    "29/02/2024",
    "5/03/2024",
  ];

  List subtitle = [
    "Sprzątanie",
    "Zakupy",
    "Dostawy",
    "Księgowość",
    "Finanse",
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Container(
        // height: 450,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire!.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Lista zadań",
                    style: mediumBlackTextStyle.copyWith(
                        color: notifire!.getMainText),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset("assets/info-circle.svg",
                      height: 22,
                      width: 22,
                      colorFilter: ColorFilter.mode(
                          notifire!.getMainText, BlendMode.srcIn)),
                  const Spacer(),
                  Text(
                    "Zobacz więcej",
                    style: mediumGreyTextStyle,
                  ),
                  SvgPicture.asset("assets/angle-right-small.svg",
                      height: 22,
                      width: 22,
                      colorFilter: ColorFilter.mode(
                          notifire!.getMainText, BlendMode.srcIn))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            logo[index],
                            width: 35,
                          ),
                        ),
                        title: Text(name[index],
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.getMainText)),
                        trailing: Column(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(price[index],
                              style: mediumBlackTextStyle.copyWith(
                                  color: notifire!.getMainText)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(date[index], style: mediumGreyTextStyle),
                        ]),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child:
                              Text(subtitle[index], style: mediumGreyTextStyle),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
