import 'package:flutter/material.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';

class ComunTextField extends StatefulWidget {
  final bool? enable;
  final String title;
  final String hinttext;
  final TextEditingController controller;
  const ComunTextField(
      {Key? key,
      required this.title,
      required this.hinttext,
      required this.controller,
      this.enable})
      : super(key: key);

  @override
  State<ComunTextField> createState() => _ComunTextFieldState();
}

class _ComunTextFieldState extends State<ComunTextField> {
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
            enabled: widget.enable,
            validator: (value) {
              if ((value == null || value.isEmpty) && (widget.enable == true)) {
                return 'Proszę uzupełnij to pole';
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
