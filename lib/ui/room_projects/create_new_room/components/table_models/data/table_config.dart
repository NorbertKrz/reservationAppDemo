import 'package:reservation_app/tools/enum/table_type.dart';

class TableConfig {
  final TableType type;
  final int chairsCount;
  final bool chairsAtEndsOn;

  TableConfig({
    required this.type,
    required this.chairsCount,
    required this.chairsAtEndsOn,
  });
}
