import 'package:get/get.dart';
import 'package:reservation_app/ui/homepage.dart';
import 'package:reservation_app/ui/login_signup/singup_screen.dart';
// import 'package:reservation_app/ui/login_signup/splash_screen.dart';

class Routes {
  // static String initial = "/";
  static String login = "/login";
  static String homepage = "/homePage";
}

final getPage = [
  // GetPage(
  //   name: Routes.initial,
  //   page: () => SplashScreen(
  //     loginState: false,
  //   ),
  // ),
  GetPage(
    name: Routes.login,
    page: () => const SingUpScreen(),
  ),
  GetPage(
    name: Routes.homepage,
    page: () => const HomePage(),
  ),
];
