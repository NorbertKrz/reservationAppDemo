import 'package:flutter/material.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';

class DayCheckBox extends StatefulWidget {
  final List<bool> openDays;
  final double width;
  final Function callback;
  const DayCheckBox(
      {super.key,
      required this.openDays,
      required this.width,
      required this.callback});

  @override
  DayCheckBoxState createState() => DayCheckBoxState();
}

class DayCheckBoxState extends State<DayCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          style: mediumBlackTextStyle.copyWith(color: notifire!.getMainText),
          "Dni tygodnia otwarcia restauracji",
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: widget.width >= 600
              ? Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('pon.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[0],
                        dense: true,
                        value: widget.openDays[0],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[0] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('wt.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[1],
                        dense: true,
                        value: widget.openDays[1],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[1] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('śr.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[2],
                        dense: true,
                        value: widget.openDays[2],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[2] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('czw.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[3],
                        dense: true,
                        value: widget.openDays[3],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[3] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('pt.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[4],
                        dense: true,
                        value: widget.openDays[4],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[4] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('sob.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[5],
                        dense: true,
                        value: widget.openDays[5],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[5] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        side: BorderSide(color: notifire!.getMaingey, width: 2),
                        title: Text('ndz.',
                            style: mediumBlackTextStyle.copyWith(
                                color: notifire!.geticoncolor)),
                        activeColor: appMainColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        checkColor: Colors.white,
                        selected: widget.openDays[6],
                        dense: true,
                        value: widget.openDays[6],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.openDays[6] = value!;
                            widget.callback(widget.openDays);
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('pon.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[0],
                            dense: true,
                            value: widget.openDays[0],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[0] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('wt.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[1],
                            dense: true,
                            value: widget.openDays[1],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[1] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('śr.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[2],
                            dense: true,
                            value: widget.openDays[2],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[2] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('czw.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[3],
                            dense: true,
                            value: widget.openDays[3],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[3] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('pt.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[4],
                            dense: true,
                            value: widget.openDays[4],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[4] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('sob.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[5],
                            dense: true,
                            value: widget.openDays[5],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[5] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            side: BorderSide(
                                color: notifire!.getMaingey, width: 2),
                            title: Text('ndz.',
                                style: mediumBlackTextStyle.copyWith(
                                    color: notifire!.geticoncolor)),
                            activeColor: appMainColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 0.0),
                            checkColor: Colors.white,
                            selected: widget.openDays[6],
                            dense: true,
                            value: widget.openDays[6],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                widget.openDays[6] = value!;
                                widget.callback(widget.openDays);
                              });
                            },
                          ),
                        ),
                        const Expanded(child: Text(''))
                      ],
                    ),
                  ],
                ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
