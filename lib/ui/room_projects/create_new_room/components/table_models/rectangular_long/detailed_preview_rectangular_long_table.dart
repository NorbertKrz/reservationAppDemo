import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/booking_popup/booking_popup_window.dart';
import 'rectangular_long_table.dart';

class DetailedPreviewRectangularLongTable extends StatefulWidget {
  final DocumentReference organizationReference;
  final TableDetailedData tableDetailedData;
  const DetailedPreviewRectangularLongTable({
    super.key,
    required this.organizationReference,
    required this.tableDetailedData,
  });

  @override
  State<DetailedPreviewRectangularLongTable> createState() =>
      _DetailedPreviewRectangularLongTableState();
}

class _DetailedPreviewRectangularLongTableState
    extends State<DetailedPreviewRectangularLongTable> {
  bool scrolling = false;
  bool showPopup = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                left: widget.tableDetailedData.offset.dx -
                    widget.tableDetailedData.tableSize / 2,
                top: widget.tableDetailedData.offset.dy -
                    widget.tableDetailedData.tableSize / 2,
                child: CustomPaint(
                  painter: RectangularLongTablePainter(
                      chairsCount: widget.tableDetailedData.maxPeople.toInt(),
                      widgetSize: widget.tableDetailedData.tableSize.toDouble(),
                      chairsAtEnds: widget.tableDetailedData.chairsAtEndsOn,
                      color: showPopup
                          ? const Color.fromARGB(255, 23, 109, 26)
                          : const Color(0xFF2446a1)),
                  child: GestureDetector(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: MouseRegion(
                      cursor: scrolling
                          ? SystemMouseCursors.move
                          : SystemMouseCursors.click,
                      child: SizedBox(
                        width: widget.tableDetailedData.tableSize.toDouble(),
                        height: widget.tableDetailedData.tableSize.toDouble(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BookingPopupWindow(
          organizationReference: widget.organizationReference,
          tableDetailedData: widget.tableDetailedData,
        );
      },
    );
  }
}
