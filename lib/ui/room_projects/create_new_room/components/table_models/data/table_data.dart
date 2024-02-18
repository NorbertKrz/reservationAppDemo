import 'package:flutter/material.dart';

class TableData {
  final double tableSize;
  final bool scrolling;
  final Offset offset;
  final int maxPeople;

  TableData({
    required this.tableSize,
    required this.scrolling,
    required this.offset,
    required this.maxPeople,
  });
}
