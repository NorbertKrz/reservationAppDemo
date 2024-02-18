import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/repositories/user/firebase_auth_provider.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_data/global_variables.dart';
import 'package:reservation_app/ui/homepage.dart';
import 'package:reservation_app/ui/login_signup/singup_screen.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:version/version.dart';
import 'business_logic/bloc/user/user_bloc.dart';
import 'business_logic/repositories/organization/organization_repository.dart';
import 'firebase_options.dart';

void main() async {
  currentVersion = Version(1, 0, 0);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loginStatus = false;
  Role role = Role.viewer;
  late DocumentReference? orgRef;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(FirebaseAuthProvider()),
        ),
        BlocProvider<OrganizationBloc>(
            create: ((context) => OrganizationBloc(OrganizationRepository()))),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            loginStatus = true;
            role = state.user.role!;
            orgRef = state.user.organizationRef;

            if (orgRef!.id.isNotEmpty) {
              debugPrint("isDefinedAndNotNull");
              context
                  .read<OrganizationBloc>()
                  .add(OrganizationPobierz(orgRef!, role));
            } else {
              debugPrint(' NIE isDefinedAndNotNull');
            }
          } else {
            loginStatus = false;
          }
          if (state is InitialAuthenticationState) {
            context.read<UserBloc>().add(AuthInitializeEvent());
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ColorProvider(),
              ),
            ],
            child: GetMaterialApp(
              locale: const Locale('pl', 'PL'),
              translations: AppTranslations(),
              scrollBehavior: MyCustomScrollBehavior(),
              debugShowCheckedModeBanner: false,
              home: loginStatus ? const HomePage() : const SingUpScreen(),
              title: 'title'.tr,
              theme: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  fontFamily: "Gilroy",
                  dividerColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: const Color(0xFF0059E7),
                  )),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is AuthStateLoggedIn) {
              return const HomePage();
            } else {
              return const SingUpScreen();
            }
          },
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //test TODO
        'en_US': {
          'enter_mail': 'Enter your email',
          'title': 'Your Table',
        },
        'pl_PL': {
          'enter_mail': 'Wpisz swój email',
          'title': 'Twój Stolik',
        },
      };
}
