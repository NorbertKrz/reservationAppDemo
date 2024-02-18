import 'package:reservation_app/tools/enum/role.dart';

String roleDecoderFnc(Role roleString) {
  switch (roleString) {
    case Role.superAdmin:
      return "Superadministrator";
    case Role.admin:
      return "Administrator";
    case Role.manager:
      return "Menedżer";
    case Role.user:
      return "Użytkownik";
    case Role.viewer:
      return "Odwiedzający";
    default:
      return "Role.viewer";
  }
}
