import 'package:flutter/foundation.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';

class TableImagePicker extends StatefulWidget {
  final Function callbackImage;
  const TableImagePicker({Key? key, required this.callbackImage})
      : super(key: key);

  @override
  TableImagePickerState createState() => TableImagePickerState();
}

class TableImagePickerState extends State<TableImagePicker>
    with SingleTickerProviderStateMixin {
  AnimationController? loadingController;
  FilePickerResult? result;
  Uint8List fileBytes = Uint8List.fromList([]);
  String fileName = '';
  String fileExtension = '';
  bool loading = false;

  String? getFileExtension(Uint8List data) {
    final mimeType = lookupMimeType('', headerBytes: data);
    final extension = extensionFromMime(mimeType!);
    return extension.replaceAll('.', '');
    // List<int> bytes = data.cast<int>();
    // final mimeType = lookupMimeType('', headerBytes: bytes);
    // String format = '';
    // if (mimeType != null) {
    //   var type = mimeType.split('/');
    //   if (type.length > 1) {
    //     format = type[1];
    //     return format;
    //   }
    // }
    // return format;
  }

  selectFile() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'svg']);

    if (result != null) {
      setState(() {
        fileBytes = result!.files.first.bytes!;
        fileName = result!.files.first.name;
        fileExtension = getFileExtension(fileBytes)!;
        widget.callbackImage(fileBytes, fileExtension);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ColorProvider>(
        builder: (context, value, child) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          fileBytes.isEmpty || fileName.isEmpty
                              ? SizedBox(
                                  height: 45,
                                  child: SvgPicture.asset(
                                      colorFilter: const ColorFilter.mode(
                                          Color(0xff8276ff), BlendMode.srcIn),
                                      "assets/cloud-upload.svg",
                                      height: 25,
                                      width: 25),
                                )
                              : SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Image.memory(fileBytes)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Upuść zdjęcie lub kliknij, aby przesłać.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, color: notifire!.getMainText),
                          ),
                          Text(
                            'Dopuszczalne rozszerzenia: PNG, JPG, SVG',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade400),
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
