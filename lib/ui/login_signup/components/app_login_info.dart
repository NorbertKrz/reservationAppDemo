import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLoginInfo extends StatefulWidget {
  const AppLoginInfo({Key? key}) : super(key: key);

  @override
  State<AppLoginInfo> createState() => _AppLoginInfoState();
}

class _AppLoginInfoState extends State<AppLoginInfo> {
  ColorProvider notifire = ColorProvider();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Consumer<ColorProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 600,
          color: notifire.getbgcolor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                width: 400,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 33,
              ),
              Text(
                "Zarządzaj, rezerwuj, kontroluj",
                style: mainTextStyle.copyWith(color: notifire.getMainText),
              ),
              const SizedBox(
                height: 4,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Aplikacja dostępna także na platformie ",
                    style: mediumBlackTextStyle.copyWith(
                        color: notifire.getMainText)),
                TextSpan(
                    text: "Android ",
                    style: mediumBlackTextStyle.copyWith(color: appMainColor)),
                TextSpan(
                    text: "oraz ",
                    style: mediumBlackTextStyle.copyWith(
                        color: notifire.getMainText)),
                TextSpan(
                    text: "iOS",
                    style: mediumBlackTextStyle.copyWith(color: appMainColor)),
              ])),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Aplikacja do zarządzania rezerwacjami, pracownikami, restauracją.",
                  style: mediumGreyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
