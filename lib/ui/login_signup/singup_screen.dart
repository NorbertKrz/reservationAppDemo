import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/repositories/user/auth_exceptions.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/login_signup/components/app_login_info.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlEmailLogin = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  TextEditingController ctrlPasswordLogin = TextEditingController();
  TextEditingController ctrlConfirmPassword = TextEditingController();
  TextEditingController ctrlName = TextEditingController();
  TextEditingController ctrlSurname = TextEditingController();
  final _formKeySignUp = GlobalKey<FormState>();
  final _formKeySignIn = GlobalKey<FormState>();
  ColorProvider notifire = ColorProvider();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Brak użytkownika o podanym adresie email.')));
          }
          if (state.exception is WrongPasswordAuthException ||
              state.exception is InvalidEmailAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content:
                    Text('Nieprawidłowe dane logowania. Spróbuj ponownie.')));
          }
          if (state.exception is UnknownAuthException ||
              state.exception is GenericAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                    'Problem z przetworzeniem żądania. Spróbuj ponownie.')));
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Consumer<ColorProvider>(
            builder: (context, value, child) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: notifire.getPrimeryColor,
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 600) {
                      // Mobile layout
                      return Container(
                        color: notifire.getbgcolor,
                        height: 900,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildlogin(width: constraints.maxWidth)
                            ],
                          ),
                        ),
                      );
                    } else if (constraints.maxWidth < 1200) {
                      return Container(
                        color: constraints.maxWidth < 860
                            ? notifire.getbgcolor
                            : notifire.getPrimeryColor,
                        height: 1000,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              constraints.maxWidth < 860
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 80),
                                      child: _buildlogin(
                                          width: constraints.maxWidth),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 80),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 782,
                                                decoration: BoxDecoration(
                                                  color: notifire.getbgcolor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(37)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: _buildlogin(
                                                          width: constraints
                                                              .maxWidth),
                                                    ),
                                                    const Expanded(
                                                      child: AppLoginInfo(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Website layout
                      return SizedBox(
                        height: 1000,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 80),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 762,
                                          decoration: BoxDecoration(
                                            color: notifire.getbgcolor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(37)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _buildlogin(
                                                    width:
                                                        constraints.maxWidth),
                                              ),
                                              const Expanded(
                                                child: AppLoginInfo(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildlogin({required double width}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          height: 734,
          decoration: BoxDecoration(
            color: notifire.getPrimeryColor,
            borderRadius: const BorderRadius.all(Radius.circular(37)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width < 600 ? 20 : 50.0,
                vertical: width < 600 ? 40 : 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: TabBarView(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Zaloguj się",
                            style: mainTextStyle.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: notifire.getMainText),
                            maxLines: 2),
                        const SizedBox(
                          height: 3,
                        ),
                        Text('Podaj swój e-mail oraz hasło',
                            style: mediumGreyTextStyle.copyWith(fontSize: 16),
                            maxLines: 2),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Utwórz konto",
                          style: mainTextStyle.copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: notifire.getMainText),
                          maxLines: 2,
                        ),
                        Text("Zajmie Ci to mniej niż minutę.",
                            style: mediumGreyTextStyle.copyWith(fontSize: 16),
                            maxLines: 2),
                      ],
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 21,
                ),
                Container(
                  height: 50,
                  width: 300,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: notifire.getbgcolor,
                      borderRadius: BorderRadius.circular(20)),
                  child: TabBar(
                      labelPadding: const EdgeInsets.all(8),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: appMainColor,
                      ),
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: notifire.getMainText,
                      tabs: const [
                        Text('Zaloguj się'),
                        Text('Zarejestruj się'),
                      ]),
                ),
                const SizedBox(
                  height: 26.8,
                ),
                Flexible(
                  child: TabBarView(children: [
                    Form(
                      key: _formKeySignIn,
                      child: Column(
                        children: [
                          buildTextFilde(
                            hideText: false,
                            controller: ctrlEmailLogin,
                            hinttext: "Adres e-mail",
                            prefixicon: "svg/at.svg",
                            suffixistrue: false,
                          ),
                          const SizedBox(
                            height: 19.8,
                          ),
                          buildTextFilde(
                              hideText: true,
                              controller: ctrlPasswordLogin,
                              hinttext: "Hasło",
                              prefixicon: "assets/lock.svg",
                              suffixistrue: true,
                              suffix: 'assets/eye.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKeySignIn.currentState!.validate()) {
                                  context.read<UserBloc>().add(AuthLogInEvent(
                                      ctrlEmailLogin.value.text,
                                      ctrlPasswordLogin.value.text));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Uzupełnij poprawnie wszystkie pola, aby przejść dalej.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: appMainColor,
                                  elevation: 0,
                                  fixedSize: const Size.fromHeight(60)),
                              child: Row(
                                children: [
                                  const Expanded(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  Text("Zaloguj się",
                                      style: mediumBlackTextStyle.copyWith(
                                          color: Colors.white)),
                                  const Expanded(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                        child: SvgPicture.asset(
                                      "assets/arrow-right-small.svg",
                                      width: 12,
                                      height: 12,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    )),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKeySignUp,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: buildTextFilde(
                                  hideText: false,
                                  controller: ctrlName,
                                  hinttext: "Imię",
                                  prefixicon: "svg/user.svg",
                                  suffixistrue: false,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: buildTextFilde(
                                  hideText: false,
                                  controller: ctrlSurname,
                                  hinttext: "Nazwisko",
                                  prefixicon: "svg/user.svg",
                                  suffixistrue: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 19.8,
                          ),
                          buildTextFilde(
                            hideText: false,
                            controller: ctrlEmail,
                            hinttext: "Adres e-mail",
                            prefixicon: "svg/at.svg",
                            suffixistrue: false,
                          ),
                          const SizedBox(
                            height: 19.8,
                          ),
                          buildTextFilde(
                              hideText: true,
                              controller: ctrlPassword,
                              hinttext: "Hasło",
                              prefixicon: "assets/lock.svg",
                              suffixistrue: true,
                              suffix: 'assets/eye.svg'),
                          const SizedBox(
                            height: 19.8,
                          ),
                          buildTextFilde(
                              hideText: true,
                              controller: ctrlConfirmPassword,
                              hinttext: "Powtórz hasło",
                              prefixicon: "assets/lock.svg",
                              suffixistrue: true,
                              suffix: 'assets/eye.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_formKeySignUp.currentState!.validate()) {
                                  if (ctrlPassword.value.text ==
                                      ctrlConfirmPassword.value.text) {
                                    context.read<UserBloc>().add(
                                        AuthRegisterEvent(
                                            ctrlEmail.value.text,
                                            ctrlPassword.value.text,
                                            ctrlName.value.text,
                                            ctrlSurname.value.text));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Wprowadzone hasła są niezgodne. Spróbuj ponownie.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Uzupełnij poprawnie wszystkie pola, aby przejść dalej.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: appMainColor,
                                  elevation: 0,
                                  fixedSize: const Size.fromHeight(60)),
                              child: Row(
                                children: [
                                  const Expanded(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  Text(
                                    "Utwórz konto",
                                    style: mediumBlackTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                  const Expanded(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                        child: SvgPicture.asset(
                                            "assets/arrow-right-small.svg",
                                            width: 12,
                                            height: 12,
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn))),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildTextFilde(
      {required String hinttext,
      required String prefixicon,
      required TextEditingController controller,
      required bool hideText,
      String? suffix,
      required bool suffixistrue}) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole jest wymagane';
        }
        return null;
      },
      obscureText: obscureText && hideText,
      controller: controller,
      style: TextStyle(color: notifire.getMainText),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: notifire.isDark
                    ? notifire.geticoncolor
                    : Colors.grey.shade200)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: notifire.isDark
                    ? notifire.geticoncolor
                    : Colors.grey.shade200)),
        hintText: hinttext,
        hintStyle: mediumGreyTextStyle,
        prefixIcon: SizedBox(
          height: 20,
          width: 50,
          child: Center(
              child: SvgPicture.asset(prefixicon,
                  height: 18,
                  width: 18,
                  colorFilter: ColorFilter.mode(
                      notifire.geticoncolor, BlendMode.srcIn))),
        ),
        suffixIcon: suffixistrue
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  height: 20,
                  width: 40,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: Center(
                          child: SvgPicture.asset(suffix!,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(
                                  notifire.geticoncolor, BlendMode.srcIn))),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
