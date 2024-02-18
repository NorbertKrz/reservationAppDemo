import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:flutter/material.dart';

class ComunTextFieldDescription extends StatefulWidget {
  final String title;
  final String hinttext;
  final TextEditingController controller;
  const ComunTextFieldDescription(
      {Key? key,
      required this.title,
      required this.hinttext,
      required this.controller})
      : super(key: key);

  @override
  State<ComunTextFieldDescription> createState() =>
      _ComunTextFieldDescriptionState();
}

class _ComunTextFieldDescriptionState extends State<ComunTextFieldDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: mediumBlackTextStyle.copyWith(color: notifire!.getMainText),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 100,
          child: TextFormField(
            style: mediumBlackTextStyle.copyWith(color: notifire!.getMainText),
            maxLines: 3,
            enabled: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wpisz proszę jakiś tekst';
              }
              return null;
            },
            decoration: InputDecoration(
                hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                hintText: widget.hinttext,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
