import 'package:reservation_app/ui/room_projects/create_new_room/listener/control_listener.dart';
import 'package:flutter/material.dart';

class ZoomButtons extends StatefulWidget {
  const ZoomButtons({Key? key}) : super(key: key);

  @override
  ZoomButtonsState createState() => ZoomButtonsState();
}

class ZoomButtonsState extends State<ZoomButtons>
    with SingleTickerProviderStateMixin {
  int stepMove = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            controlButtonsListener.value = ControlButtonsData(
                stepMove: stepMove,
                ctrlLeft: false,
                ctrlRight: false,
                ctrlTop: false,
                ctrlBottom: false,
                ctrlRotate: false,
                zoomIn: true,
                zoomOut: false);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(40, 35),
            backgroundColor: const Color(0xFF2446a1),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
            ),
          ),
          child: const Icon(Icons.add),
        ),
        const VerticalDivider(width: 1, thickness: 1, color: Colors.white),
        ElevatedButton(
          onPressed: () {
            controlButtonsListener.value = ControlButtonsData(
                stepMove: stepMove,
                ctrlLeft: false,
                ctrlRight: false,
                ctrlTop: false,
                ctrlBottom: false,
                ctrlRotate: false,
                zoomIn: false,
                zoomOut: true);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(40, 35),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
            ),
            backgroundColor: const Color(0xFF2446a1),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green;
                }
                return const Color(0xFF2446a1);
              },
            ),
          ),
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
