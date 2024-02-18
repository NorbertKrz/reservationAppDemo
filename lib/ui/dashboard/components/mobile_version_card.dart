import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileVersionCard extends StatefulWidget {
  final double width;
  const MobileVersionCard({
    super.key,
    required this.width,
  });

  @override
  State<MobileVersionCard> createState() => _MobileVersionCardState();
}

class _MobileVersionCardState extends State<MobileVersionCard> {
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.blueAccent.withOpacity(0.2),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Zarządzaj restauracją również przez urządzenia mobilne",
                        style: mainTextStyle.copyWith(
                            color: notifire!.getTextColor1,
                            fontSize: 26,
                            fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 32,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffffc107),
                        ),
                        child: Center(
                            child: Text("Czytaj więcej",
                                style: mediumBlackTextStyle)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Bądź dostępny dla swoich klientów 24/7',
                          style: mediumGreyTextStyle.copyWith(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                      const SizedBox(
                        height: 55,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1e1e1e),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              fixedSize: const Size(100, 42)),
                          onPressed: () async {
                            const url =
                                'https://drive.google.com/file/d/1RVrFsDuxwzBAVjvWHfAkzpxr0DKKCd7O/view?usp=drive_link'; // Replace with your Google Drive link

                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                          child: Text(
                            "Pobierz",
                            style: mediumBlackTextStyle.copyWith(
                                color: Colors.white),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Aplikacja na platformy Android i iOS',
                          style: mediumGreyTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.asset("images/phone_dashboard.png",
                  height: widget.width < 600 ? 280 : 350,
                  width: widget.width < 600 ? 280 : 350,
                  fit: BoxFit.contain),
            )
          ],
        ),
      ),
    );
  }
}
