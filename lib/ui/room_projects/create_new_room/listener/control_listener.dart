import 'package:flutter/material.dart';

final ValueNotifier<ControlButtonsData> controlButtonsListener =
    ValueNotifier<ControlButtonsData>(ControlButtonsData(
        stepMove: 1,
        ctrlLeft: false,
        ctrlRight: false,
        ctrlTop: false,
        ctrlBottom: false,
        ctrlRotate: false,
        zoomIn: false,
        zoomOut: false));

class ControlButtonsData {
  int stepMove;
  bool ctrlLeft;
  bool ctrlRight;
  bool ctrlTop;
  bool ctrlBottom;
  bool ctrlRotate;
  bool zoomIn;
  bool zoomOut;

  ControlButtonsData({
    required this.stepMove,
    required this.ctrlLeft,
    required this.ctrlRight,
    required this.ctrlTop,
    required this.ctrlBottom,
    required this.ctrlRotate,
    required this.zoomIn,
    required this.zoomOut,
  });
}
