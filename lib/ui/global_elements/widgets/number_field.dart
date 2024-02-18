import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';

class ComunNumberField extends StatefulWidget {
  final String title;
  final String hinttext;
  final TextEditingController controller;
  const ComunNumberField(
      {Key? key,
      required this.title,
      required this.hinttext,
      required this.controller})
      : super(key: key);

  @override
  State<ComunNumberField> createState() => _ComunNumberFieldState();
}

class _ComunNumberFieldState extends State<ComunNumberField> {
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
          child: TextFormField(
            style: mediumBlackTextStyle.copyWith(color: notifire!.getMainText),
            enabled: true,
            // maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Proszę uzupełnij to pole wartością liczbową';
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
