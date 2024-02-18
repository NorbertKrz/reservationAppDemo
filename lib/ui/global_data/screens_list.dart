import 'package:reservation_app/ui/dashboard/dashboard_screen.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/create_new_room_step1_screen.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/create_new_room_step2_screen.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/create_new_room_step3_screen.dart';
import 'package:reservation_app/ui/room_projects/project_room_list/project_list_screen.dart';
import 'package:get/get.dart';
import 'package:reservation_app/ui/room_projects/room_view/room_view_screen.dart';
import 'package:reservation_app/ui/user_profile/user_profile_screen.dart';
import '../login_signup/singup_screen.dart';

class AppConst extends GetxController implements GetxService {
  RxInt pageselecter = 0.obs;

  RxBool switchistrue = false.obs;

  var page = [
    const DashboardScreen(), //0
    const SingUpScreen(), //1
    const CreateNewRoomStep1Sceen(), //2
    const CreateNewRoomStep2Screen(), //3
    const CreateNewRoomStep3Screen(), //4
    const ProjectListScreen(), //5
    const RoomViewScreen(), //6
    const UserProfileScreen(), //7
    const UserProfileScreen() //8
  ].obs;

  void changePage(int newIndex) {
    pageselecter.value = newIndex;
  }
}
