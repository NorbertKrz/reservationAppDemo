import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/listener/control_listener.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  ControlButtonsState createState() => ControlButtonsState();
}

class ControlButtonsState extends State<ControlButtons>
    with SingleTickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  int stepMove = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              stepChoice(),
              const SizedBox(
                height: 2,
              ),
              Card(
                color: const Color(0xFF2446a1),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controlButtonsListener.value = ControlButtonsData(
                        stepMove: stepMove,
                        ctrlLeft: false,
                        ctrlRight: false,
                        ctrlTop: true,
                        ctrlBottom: false,
                        ctrlRotate: false,
                        zoomIn: false,
                        zoomOut: false);
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: const Color(0xFF2446a1),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controlButtonsListener.value = ControlButtonsData(
                            stepMove: stepMove,
                            ctrlLeft: true,
                            ctrlRight: false,
                            ctrlTop: false,
                            ctrlBottom: false,
                            ctrlRotate: false,
                            zoomIn: false,
                            zoomOut: false);
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   width: 40,
                  // ),
                  Card(
                    color: const Color(0xFF2446a1),
                    child: IconButton(
                      icon: const Icon(
                        Icons.rotate_right,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controlButtonsListener.value = ControlButtonsData(
                            stepMove: stepMove,
                            ctrlLeft: false,
                            ctrlRight: false,
                            ctrlTop: false,
                            ctrlBottom: false,
                            ctrlRotate: true,
                            zoomIn: false,
                            zoomOut: false);
                        //TO DO
                      },
                    ),
                  ),
                  Card(
                    color: const Color(0xFF2446a1),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controlButtonsListener.value = ControlButtonsData(
                            stepMove: stepMove,
                            ctrlLeft: false,
                            ctrlRight: true,
                            ctrlTop: false,
                            ctrlBottom: false,
                            ctrlRotate: false,
                            zoomIn: false,
                            zoomOut: false);
                      },
                    ),
                  ),
                ],
              ),
              Card(
                color: const Color(0xFF2446a1),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controlButtonsListener.value = ControlButtonsData(
                        stepMove: stepMove,
                        ctrlLeft: false,
                        ctrlRight: false,
                        ctrlTop: false,
                        ctrlBottom: true,
                        ctrlRotate: false,
                        zoomIn: false,
                        zoomOut: false);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Pozycję stolika można zmieniać także poprzez jego zaznaczenie i przenoszenia za pomocą kursora myszki.",
                    textAlign: TextAlign.center,
                    style: mediumGreyTextStyle.copyWith(fontSize: 13),
                    maxLines: 2),
              ),
            ],
          ),
        ));
  }

  Widget stepChoice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Skok:",
          textAlign: TextAlign.center,
          style: mediumGreyTextStyle.copyWith(fontSize: 15),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 35,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 20,
                height: 34,
                child: Center(
                  child: IconButton(
                      alignment: Alignment.center,
                      iconSize: 15,
                      onPressed: () {
                        if (stepMove < 20) {
                          setState(() {
                            stepMove++;
                          });
                        }
                      },
                      icon: const Icon(Icons.add)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 30,
                height: 34,
                child: Center(
                  child: Text(
                    stepMove.toString(),
                    textAlign: TextAlign.center,
                    style: mediumBlackTextStyle.copyWith(
                        fontSize: 18, color: notifire.getTextColor1),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 20,
                height: 34,
                child: Center(
                  child: IconButton(
                      alignment: Alignment.center,
                      iconSize: 15,
                      onPressed: () {
                        if (stepMove > 1) {
                          setState(() {
                            stepMove--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove)),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
