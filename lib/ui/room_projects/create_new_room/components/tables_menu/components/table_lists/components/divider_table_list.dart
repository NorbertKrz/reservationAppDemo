import 'package:flutter/material.dart';

class DividerTableList extends StatefulWidget {
  final bool verticalView;

  const DividerTableList({
    super.key,
    required this.verticalView,
  });

  @override
  State<DividerTableList> createState() => DividerTableListState();
}

class DividerTableListState extends State<DividerTableList> {
  double space = 25;

  @override
  Widget build(BuildContext context) {
    return widget.verticalView
        ? Column(
            children: [
              SizedBox(
                height: space,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                    height: 1, color: Color.fromARGB(255, 189, 189, 189)),
              ),
              SizedBox(
                height: space,
              ),
            ],
          )
        : const IntrinsicHeight(
            child: SizedBox(
              width: 60,
              height: 20,
              child: VerticalDivider(
                thickness: 1,
                width: 50,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
            ),
          );
  }
}
