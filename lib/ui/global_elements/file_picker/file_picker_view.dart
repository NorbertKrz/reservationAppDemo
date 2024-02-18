// ignore_for_file: deprecated_member_use

import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../global_style_data/styles.dart';

class FilePickerView extends StatefulWidget {
  const FilePickerView({Key? key}) : super(key: key);

  @override
  FilePickerViewState createState() => FilePickerViewState();
}

class FilePickerViewState extends State<FilePickerView>
    with SingleTickerProviderStateMixin {
  AnimationController? loadingController;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'svg']);

    if (file != null) {
      setState(() {});
    }

    loadingController!.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ColorProvider>(
        builder: (context, value, child) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: selectFile,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: const Color(0xff8276ff),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/cloud-upload.svg",
                              height: 25,
                              width: 25,
                              color: const Color(0xff8276ff)),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Upuść pliki tutaj lub kliknij, aby przesłać.',
                            style: TextStyle(
                                fontSize: 16, color: notifire!.getMainText),
                          ),
                          Text(
                            'Dopuszczalne rozszerzenia plików: PNG, JPG, SVG',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
