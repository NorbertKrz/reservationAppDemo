import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/user_model.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/global_elements/bottom_bar/bottom_bar.dart';
import 'package:reservation_app/ui/global_elements/widgets/path_view_title.dart';
import 'package:reservation_app/ui/global_elements/widgets/number_field.dart';
import 'package:reservation_app/ui/global_elements/widgets/text_field.dart';
import 'package:reservation_app/ui/global_elements/widgets/text_field_description.dart';
import 'package:reservation_app/ui/room_projects/create_new_room/components/checkbox/day_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:reservation_app/ui/global_data/screens_list.dart';

class CreateNewRoomStep1Sceen extends StatefulWidget {
  const CreateNewRoomStep1Sceen({Key? key}) : super(key: key);

  @override
  State<CreateNewRoomStep1Sceen> createState() =>
      _CreateNewRoomStep1SceenState();
}

class _CreateNewRoomStep1SceenState extends State<CreateNewRoomStep1Sceen> {
  final TextEditingController _ctrlProjectName = TextEditingController();
  final TextEditingController _ctrlCity = TextEditingController();
  final TextEditingController _ctrlPostCode = TextEditingController();
  final TextEditingController _ctrlStreetNumber = TextEditingController();
  final TextEditingController _ctrlLevelQuantity = TextEditingController();
  final TextEditingController _ctrlRoomQuantity = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();
  final TextEditingController _ctrlOpenTime = TextEditingController();
  final TextEditingController _ctrlCloseTime = TextEditingController();
  final List<TextEditingController> _ctrlOpeningList =
      List.generate(7, (index) => TextEditingController());
  final List<TextEditingController> _ctrlClosingList =
      List.generate(7, (index) => TextEditingController());
  bool _diffrentHoursCheckBox = false;
  late List<bool> _openDays = List.generate(7, (index) => true);
  ColorProvider notifire = ColorProvider();
  TimeOfDay _selectedOpenTime = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay _selectedCloseTime = const TimeOfDay(hour: 23, minute: 00);
  List weeksOpenTime = [];
  final _roomFormKey = GlobalKey<FormState>();
  List<String> dayList = [
    'Poniedziałek',
    'Wtorek',
    'Środa',
    'Czwartek',
    'Piątek',
    'Sobota',
    'Niedziela'
  ];

  callback(List<bool> list) {
    setState(() {
      _openDays = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return GetBuilder<AppConst>(builder: (builderController) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: notifire.getbgcolor,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout
              return SizedBox(
                height: 900,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const PathViewTitle(
                          title: 'O restauracji', path: "Projekt sali"),
                      Row(
                        children: [
                          Expanded(
                              child: _viewSmall(
                                  builderController, constraints.maxWidth))
                        ],
                      ),
                      const BottomBar(),
                    ],
                  ),
                ),
              );
            } else if (constraints.maxWidth < 1000) {
              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const PathViewTitle(
                          title: 'O restauracji', path: "Projekt sali"),
                      Row(
                        children: [
                          Expanded(
                              child: _viewMedium(
                                  builderController, constraints.maxWidth))
                        ],
                      ),
                      const BottomBar(),
                    ],
                  ),
                ),
              );

              // Tablet layout
            } else {
              // Website layout
              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const PathViewTitle(
                          title: 'O restauracji', path: "Projekt sali"),
                      Row(
                        children: [
                          Expanded(
                              child: _viewBig(
                                  builderController, constraints.maxWidth))
                        ],
                      ),
                      const BottomBar(),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  Widget _viewBig(AppConst controller, double width) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // height: 900,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Form(
          key: _roomFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ComunTextField(
                        title: 'Miasto',
                        hinttext: 'Gdańsk',
                        controller: _ctrlCity,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunTextField(
                        title: 'Kod pocztowy',
                        hinttext: '80-748',
                        controller: _ctrlPostCode,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunTextField(
                        title: 'Ulica i numer',
                        hinttext: 'Chmielna 3/7',
                        controller: _ctrlStreetNumber,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ComunTextField(
                          title: 'Nazwa Twojej restauracji',
                          hinttext: 'Chleb i Wino',
                          controller: _ctrlProjectName,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunNumberField(
                        title: 'Ilość sal restauracyjnych',
                        hinttext: 'np. 2',
                        controller: _ctrlRoomQuantity,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunNumberField(
                        title: 'Ilość poziomów',
                        hinttext: 'np. 1',
                        controller: _ctrlLevelQuantity,
                      )),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _diffrentHoursCheckBox
                          ? Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  DayCheckBox(
                                      openDays: _openDays,
                                      width: width,
                                      callback: callback),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildOpeningTimeColumn(
                                              dayList, _ctrlOpeningList)),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: _buildClosingTimeColumn(
                                              dayList, _ctrlClosingList)),
                                    ],
                                  )
                                ],
                              ))
                          : Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(child: _buildOpenTime()),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(child: _buildCloseTime()),
                                ],
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: _buildCheckbox(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnterDetails(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  nextStepButton(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewMedium(AppConst controller, double width) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // height: 900,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Form(
          key: _roomFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ComunTextField(
                        title: 'Miasto',
                        hinttext: 'Gdańsk',
                        controller: _ctrlCity,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunTextField(
                        title: 'Kod pocztowy',
                        hinttext: '80-748',
                        controller: _ctrlPostCode,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ComunTextField(
                          title: 'Nazwa Twojej restauracji',
                          hinttext: 'Chleb i Wino',
                          controller: _ctrlProjectName,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunTextField(
                        title: 'Ulica i numer',
                        hinttext: 'Chmielna 3/7',
                        controller: _ctrlStreetNumber,
                      )),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: ComunNumberField(
                        title: 'Ilość sal restauracyjnych',
                        hinttext: 'np. 2',
                        controller: _ctrlRoomQuantity,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ComunNumberField(
                        title: 'Ilość poziomów',
                        hinttext: 'np. 1',
                        controller: _ctrlLevelQuantity,
                      )),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  _buildCheckbox(),
                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _diffrentHoursCheckBox
                          ? Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  DayCheckBox(
                                      openDays: _openDays,
                                      width: width,
                                      callback: callback),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildOpeningTimeColumn(
                                              dayList, _ctrlOpeningList)),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: _buildClosingTimeColumn(
                                              dayList, _ctrlClosingList)),
                                    ],
                                  )
                                ],
                              ))
                          : Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(child: _buildOpenTime()),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(child: _buildCloseTime()),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnterDetails(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  nextStepButton(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewSmall(AppConst controller, double width) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // height: 900,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Form(
          key: _roomFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComunTextField(
                    title: 'Miasto',
                    hinttext: 'Gdańsk',
                    controller: _ctrlCity,
                  ),
                  const SizedBox(height: 20.0),
                  ComunTextField(
                    title: 'Kod pocztowy',
                    hinttext: '80-748',
                    controller: _ctrlPostCode,
                  ),
                  const SizedBox(height: 20.0),
                  ComunTextField(
                    title: 'Nazwa Twojej restauracji',
                    hinttext: 'Chleb i Wino',
                    controller: _ctrlProjectName,
                  ),
                  const SizedBox(height: 20.0),
                  ComunTextField(
                    title: 'Ulica i numer',
                    hinttext: 'Chmielna 3/7',
                    controller: _ctrlStreetNumber,
                  ),
                  const SizedBox(height: 20.0),
                  ComunNumberField(
                    title: 'Ilość sal restauracyjnych',
                    hinttext: 'np. 2',
                    controller: _ctrlRoomQuantity,
                  ),
                  const SizedBox(height: 20.0),
                  ComunNumberField(
                    title: 'Ilość poziomów',
                    hinttext: 'np. 1',
                    controller: _ctrlLevelQuantity,
                  ),
                  const SizedBox(height: 20.0),
                  _buildCheckbox(),
                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _diffrentHoursCheckBox
                          ? Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  DayCheckBox(
                                      openDays: _openDays,
                                      width: width,
                                      callback: callback),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildOpeningTimeColumn(
                                              dayList, _ctrlOpeningList)),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: _buildClosingTimeColumn(
                                              dayList, _ctrlClosingList)),
                                    ],
                                  )
                                ],
                              ))
                          : Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(child: _buildOpenTime()),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(child: _buildCloseTime()),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnterDetails(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  nextStepButton(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectCloseTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedCloseTime,
      cancelText: 'Wstecz',
      confirmText: 'Zatwierdź',
      helpText: 'Wybierz godzinę',
      hourLabelText: 'Godziny',
      minuteLabelText: 'Minuty',
      errorInvalidText: 'Nieprawidłowy format',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Builder(builder: (context) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                      brightness: Brightness.dark,
                      primary: appMainColor,
                      surface: notifire.getcontiner,
                      onSurface: notifire.geticoncolor),
                ),
                child: child!,
              );
            }));
      },
    );
    if (picked != null) {
      setState(() {
        _selectedCloseTime = picked;
        controller.text =
            '${picked.hour}:${picked.minute.toString().padLeft(2, "0")}';
      });
    }
  }

  Future<void> selectOpenTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedOpenTime,
      cancelText: 'Wstecz',
      confirmText: 'Zatwierdź',
      helpText: 'Wybierz godzinę',
      hourLabelText: 'Godziny',
      minuteLabelText: 'Minuty',
      errorInvalidText: 'Nieprawidłowy format',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Builder(builder: (context) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                      brightness: Brightness.dark,
                      primary: appMainColor,
                      surface: notifire.getcontiner,
                      onSurface: notifire.geticoncolor),
                ),
                child: child!,
              );
            }));
      },
    );
    if (picked != null) {
      setState(() {
        _selectedOpenTime = picked;
        controller.text =
            '${picked.hour}:${picked.minute.toString().padLeft(2, "0")}';
      });
    }
  }

  Widget _buildOpenTime() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          selectOpenTime(context, _ctrlOpenTime);
        },
        child: AbsorbPointer(
          child: ComunTextField(
            title: "Godziny otwarcia",
            controller: _ctrlOpenTime,
            hinttext: 'np 11:00',
          ),
        ),
      ),
    );
  }

  Widget _buildOpeningTime(
      String day, TextEditingController dayController, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enabled
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    selectOpenTime(context, dayController);
                  },
                  child: AbsorbPointer(
                    child: ComunTextField(
                      controller: dayController,
                      hinttext: "np. 11:00",
                      title: "Otwarcie - $day",
                    ),
                  ),
                ),
              )
            : AbsorbPointer(
                child: ComunTextField(
                  enable: false,
                  controller: dayController,
                  hinttext: "Zamknięte",
                  title: day,
                ),
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildOpeningTimeColumn(
      List<String> days, List<TextEditingController> openingController) {
    return Column(
      children: [
        _buildOpeningTime(dayList[0], openingController[0], _openDays[0]),
        _buildOpeningTime(dayList[1], openingController[1], _openDays[1]),
        _buildOpeningTime(dayList[2], openingController[2], _openDays[2]),
        _buildOpeningTime(dayList[3], openingController[3], _openDays[3]),
        _buildOpeningTime(dayList[4], openingController[4], _openDays[4]),
        _buildOpeningTime(dayList[5], openingController[5], _openDays[5]),
        _buildOpeningTime(dayList[6], openingController[6], _openDays[6]),
      ],
    );
  }

  Widget _buildCloseTime() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _selectCloseTime(context, _ctrlCloseTime);
        },
        child: AbsorbPointer(
          child: ComunTextField(
            title: "Godziny zamknięcia",
            controller: _ctrlCloseTime,
            hinttext: 'np 23:00',
          ),
        ),
      ),
    );
  }

  Widget _buildClosingTime(
      String day, TextEditingController dayController, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enabled
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _selectCloseTime(context, dayController);
                  },
                  child: AbsorbPointer(
                    child: ComunTextField(
                      controller: dayController,
                      hinttext: "np. 23:00",
                      title: "Zamknięcie - $day",
                    ),
                  ),
                ),
              )
            : AbsorbPointer(
                child: ComunTextField(
                  enable: false,
                  controller: dayController,
                  hinttext: "Zamknięte",
                  title: day,
                ),
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildClosingTimeColumn(
      List<String> days, List<TextEditingController> openingController) {
    return Column(
      children: [
        _buildClosingTime(dayList[0], openingController[0], _openDays[0]),
        _buildClosingTime(dayList[1], openingController[1], _openDays[1]),
        _buildClosingTime(dayList[2], openingController[2], _openDays[2]),
        _buildClosingTime(dayList[3], openingController[3], _openDays[3]),
        _buildClosingTime(dayList[4], openingController[4], _openDays[4]),
        _buildClosingTime(dayList[5], openingController[5], _openDays[5]),
        _buildClosingTime(dayList[6], openingController[6], _openDays[6]),
      ],
    );
  }

  bool checkBoxField(String text, bool select) {
    CheckboxListTile(
      title: Text(text, style: const TextStyle(fontSize: 14)),
      activeColor: appMainColor,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      checkColor: Colors.white,
      selected: select,
      dense: true,
      value: select,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          select = value!;
        });
      },
    );
    return select;
  }

  Widget _buildCheckbox() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Różne godziny otwarcia/zamknięcia",
        style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: CheckboxListTile(
          title: Text(
            'Różne godziny',
            style: mediumBlackTextStyle.copyWith(color: notifire.geticoncolor),
          ),
          side: BorderSide(color: notifire.getMaingey, width: 2),
          activeColor: appMainColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          checkColor: Colors.white,
          selected: _diffrentHoursCheckBox,
          dense: true,
          value: _diffrentHoursCheckBox,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _diffrentHoursCheckBox = value!;
            });
          },
        ),
      )
    ]);
  }

  Widget _buildEnterDetails() {
    return ComunTextFieldDescription(
      title: 'Szczegóły',
      hinttext: 'Opisz coś więcej',
      controller: _ctrlDescription,
    );
  }

  nextStepButton(AppConst controller) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        bool configPossible = false;
        if (state is AuthStateLoggedIn) {
          if (!state.user.organizationRef!.id.isNotEmpty) {
            // FUTURE: ADD plan to condition
            configPossible = true;
          } else {
            configPossible = false;
          }
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width < 600
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Visibility(
                    visible: !configPossible,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Do Twojego konta jest już przypisana organizacja (możesz to sprawdzić w zakładce "Lista projektów"). Jeżeli chcesz dodać kolejną organizację musisz wykupić wyższy plan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
                ElevatedButton(
                    onPressed: configPossible
                        ? () async {
                            if (_roomFormKey.currentState!.validate()) {
                              if (!_diffrentHoursCheckBox) {
                                weeksOpenTime.clear();
                                for (var i = 0; i < 7; i++) {
                                  weeksOpenTime.add({
                                    "day": dayList[i],
                                    "open": !_diffrentHoursCheckBox,
                                    "openTime": _ctrlOpenTime.value.text,
                                    "closeTime": _ctrlCloseTime.value.text,
                                  });
                                }
                              } else {
                                weeksOpenTime.clear();
                                for (var i = 0; i < 7; i++) {
                                  weeksOpenTime.add({
                                    "day": dayList[i],
                                    "open": _openDays[i],
                                    "openTime": _ctrlOpeningList[i].value.text,
                                    "closeTime": _ctrlClosingList[i].value.text,
                                  });
                                }
                              }
                              DocumentReference docRef = await FirebaseFirestore
                                  .instance
                                  .collection('organizations')
                                  .add({
                                'processData': {
                                  'createdTime': DateTime.now(),
                                  'creationStatus': {
                                    'status': 'inProgress',
                                    'step': 1,
                                  }
                                },
                                'general': {
                                  'name': _ctrlProjectName.value.text,
                                  'city': _ctrlCity.value.text,
                                  'postCode': _ctrlPostCode.value.text,
                                  'streetNumber': _ctrlStreetNumber.value.text,
                                  'roomQuantity':
                                      int.parse(_ctrlLevelQuantity.value.text),
                                  'levelQuantity':
                                      int.parse(_ctrlRoomQuantity.value.text),
                                  'details': _ctrlDescription.value.text,
                                  'openingTimes': weeksOpenTime,
                                },
                              });
                              if (!mounted) return;
                              UserModel user =
                                  context.read<UserBloc>().userModel!;
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .set({
                                'organizationRef': docRef,
                              }, SetOptions(merge: true));
                              controller.changePage(3);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Ups... Znalezniono błąd. Uzupełnij formularz prawidłowo, aby przejść dalej.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
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
                          "Przejdź dalej",
                          style:
                              mediumGreyTextStyle.copyWith(color: Colors.white),
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
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: SvgPicture.asset(
                            "assets/arrow-right-small.svg",
                            width: 12,
                            height: 12,
                            // ignore: deprecated_member_use
                            color: Colors.white,
                          )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
