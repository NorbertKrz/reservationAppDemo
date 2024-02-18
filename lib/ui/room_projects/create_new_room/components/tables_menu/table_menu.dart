import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/control_buttons.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/file_picker/table_image_picker.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/table_models/data/table_config.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_lists/rectangle_table_list.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/table_lists/round_table_list.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/tables_menu/components/zoom_buttons.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

class TableMenu extends StatefulWidget {
  final bool verticalView;
  final Function tableInfo;
  final Function confirm;
  const TableMenu(
      {Key? key,
      required this.tableInfo,
      required this.confirm,
      required this.verticalView})
      : super(key: key);

  @override
  State<TableMenu> createState() => _TableMenuState();
}

class _TableMenuState extends State<TableMenu>
    with SingleTickerProviderStateMixin {
  final _formKeyConfirm = GlobalKey<FormState>();
  ColorProvider notifire = ColorProvider();
  double modelSize = 20;
  bool active = false;
  int stepMove = 1;
  Uint8List tableImage = Uint8List.fromList([]);
  String fileExtension = '';
  late AnimationController _animationController;
  late Animation<Color?> colorAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.grey,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
    _animationController.repeat();
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
    _animationController.stop();
  }

  List<Widget> tableType = <Widget>[
    const Text('Prostokątny'),
    const Text('Okrągły'),
  ];
  final List<bool> _selectedTableType = <bool>[true, false];
  TextEditingController ctrlTableNo = TextEditingController();

  List<Widget> tableCapacity = <Widget>[
    const Text('1-2'),
    const Text('3-4'),
    const Text('5-9'),
    const Text('10+'),
  ];
  final List<bool> _selectedTableCapacity = <bool>[true, true, true, true];

  callbackImage(Uint8List imageData, String extension) {
    setState(() {
      tableImage = imageData;
      fileExtension = extension;
    });
  }

  callbackTableInfo(TableConfig tableConfig, bool activeBool) {
    setState(() {
      widget.tableInfo(TableConfig(
          type: tableConfig.type,
          chairsCount: tableConfig.chairsCount,
          chairsAtEndsOn: tableConfig.chairsAtEndsOn));
      active = activeBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return Container(
      width: widget.verticalView ? 300 : MediaQuery.of(context).size.width - 40,
      height: widget.verticalView
          ? MediaQuery.of(context).size.height - 155
          : !widget.verticalView && active
              ? 410
              : 250,
      decoration: BoxDecoration(
        color: notifire.getcontiner,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(alignment: Alignment.topCenter, children: [
            Visibility(
              visible: !active,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 155,
                    child: Column(
                      children: [
                        Text(
                          "Wybierz stolik",
                          style: mainTextStyle.copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: notifire.getMainText),
                          maxLines: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0;
                                    i < _selectedTableType.length;
                                    i++) {
                                  _selectedTableType[i] = i == index;
                                }
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedBorderColor: tableColor,
                            selectedColor: Colors.white,
                            fillColor: tableColor.withOpacity(0.8),
                            color: tableColor,
                            constraints: const BoxConstraints(
                              minHeight: 30.0,
                              minWidth: 110.0,
                            ),
                            isSelected: _selectedTableType,
                            children: tableType,
                          ),
                        ),
                        Text("Liczba osób",
                            style: mediumGreyTextStyle.copyWith(fontSize: 16),
                            maxLines: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                _selectedTableCapacity[index] =
                                    !_selectedTableCapacity[index];
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedBorderColor: tableColor,
                            selectedColor: Colors.white,
                            fillColor: tableColor.withOpacity(0.8),
                            color: tableColor,
                            constraints: const BoxConstraints(
                              minHeight: 25.0,
                              minWidth: 55.0,
                            ),
                            isSelected: _selectedTableCapacity,
                            children: tableCapacity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: widget.verticalView
                              ? Axis.vertical
                              : Axis.horizontal,
                          child: _selectedTableType[0]
                              ? RectangleTableList(
                                  visibilityList: _selectedTableCapacity,
                                  verticalView: widget.verticalView,
                                  callbackTableInfo: callbackTableInfo)
                              : RoundTableList(
                                  visibilityList: _selectedTableCapacity,
                                  verticalView: widget.verticalView,
                                  callbackTableInfo: callbackTableInfo))),
                ],
              ),
            ),
            Visibility(
              visible: active,
              child: widget.verticalView
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Ustawienia stolika",
                            textAlign: TextAlign.center,
                            style: mainTextStyle.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: notifire.getMainText),
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Nazwa stolika",
                                style:
                                    mediumGreyTextStyle.copyWith(fontSize: 16),
                                maxLines: 2),
                          ),
                          tableNumberField(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Pozycja stolika",
                                style:
                                    mediumGreyTextStyle.copyWith(fontSize: 16),
                                maxLines: 2),
                          ),
                          const ControlButtons(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Rozmiar stolika",
                                style:
                                    mediumGreyTextStyle.copyWith(fontSize: 16),
                                maxLines: 2),
                          ),
                          const ZoomButtons(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Zdjęcie stolika",
                                style:
                                    mediumGreyTextStyle.copyWith(fontSize: 16),
                                maxLines: 2),
                          ),
                          TableImagePicker(
                            callbackImage: callbackImage,
                          ),
                          const SizedBox(height: 10),
                          confirmButton(),
                          const SizedBox(height: 10),
                          cancelButton(),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Ustawienia stolika",
                              //   textAlign: TextAlign.center,
                              //   style: mainTextStyle.copyWith(
                              //       overflow: TextOverflow.ellipsis,
                              //       color: notifire.getMainText),
                              //   maxLines: 2,
                              // ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("Nazwa stolika",
                                          style: mediumGreyTextStyle.copyWith(
                                              fontSize: 16),
                                          maxLines: 2),
                                    ),
                                    tableNumberField(),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Zdjęcie stolika",
                                          style: mediumGreyTextStyle.copyWith(
                                              fontSize: 16),
                                          maxLines: 2),
                                    ),
                                    TableImagePicker(
                                      callbackImage: callbackImage,
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: VerticalDivider(
                                  thickness: 1,
                                  width: 30,
                                  color: Color.fromARGB(255, 189, 189, 189),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Pozycja stolika",
                                          style: mediumGreyTextStyle.copyWith(
                                              fontSize: 16),
                                          maxLines: 2),
                                    ),
                                    const ControlButtons(),
                                    const ZoomButtons(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            confirmButton(),
                            const SizedBox(width: 15),
                            cancelButton(),
                          ],
                        ),
                      ],
                    ),
            )
          ])),
    );
  }

  Widget tableNumberField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Stolik nr ",
            textAlign: TextAlign.center,
            style: mediumBlackTextStyle.copyWith(
                overflow: TextOverflow.ellipsis, color: notifire.getMainText),
            maxLines: 2,
          ),
        ),
        Expanded(
          child: Form(
            key: _formKeyConfirm,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Uzupełnij to pole';
                } else if ((int.parse(value) < 0)) {
                  return 'Min. 0';
                }
                return null;
              },
              textAlign: TextAlign.center,
              style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
              controller: ctrlTableNo,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: notifire.getMainText,
                    ),
                    borderRadius: BorderRadius.circular(25)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: 'Nr stolika',
                hintStyle: mediumGreyTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cancelButton() {
    return OutlinedButton(
        onPressed: () {
          setState(() {
            active = false;
            widget.confirm({
              'confirmState': !active,
              'tableNo': 0,
              'imageUrl': 'fgfgfdgdfg',
            });
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Anuluj'),
        ));
  }

  Widget confirmButton() {
    return ElevatedButton(
      style:
          const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(150, 40))),
      onPressed: _isLoading
          ? null
          : () async {
              if (_formKeyConfirm.currentState!.validate()) {
                startLoading();
                try {
                  TaskSnapshot uploadTask = await FirebaseStorage.instance
                      .ref('tablePhotos/${ctrlTableNo.text}.$fileExtension')
                      .putData(tableImage);
                  String downloadLink = await uploadTask.ref.getDownloadURL();

                  setState(() {
                    active = false;
                    widget.confirm({
                      'confirmState': active,
                      'tableNo': int.parse(ctrlTableNo.text),
                      'imageUrl': downloadLink,
                    });
                    ctrlTableNo.clear();
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Poprawnie dodano stolik.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  stopLoading();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Ups... Coś poszło nie tak z wgrywaniem zdjęcia. Spróbuj ponownie.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  stopLoading();
                }
              }
            },
      child: AnimatedBuilder(
        animation: colorAnimation,
        builder: (BuildContext context, _) {
          return _isLoading
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: colorAnimation,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Zatwierdź'),
                );
        },
      ),
    );
  }
}
