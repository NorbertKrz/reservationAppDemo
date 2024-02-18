import 'package:reservation_app/tools/enum/plan.dart';

String planDecoderFnc(Plan planString) {
  switch (planString) {
    case Plan.basic:
      return "Podstawowy";
    case Plan.standard:
      return "Standard";
    case Plan.pro:
      return "Pro";
    default:
      return "Podstawowy";
  }
}
