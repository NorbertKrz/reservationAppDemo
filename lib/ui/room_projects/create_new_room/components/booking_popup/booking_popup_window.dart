import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:get/get.dart';

class BookingPopupWindow extends StatefulWidget {
  final DocumentReference organizationReference;
  final TableDetailedData tableDetailedData;
  const BookingPopupWindow({
    super.key,
    required this.tableDetailedData,
    required this.organizationReference,
  });

  @override
  State<BookingPopupWindow> createState() => _BookingPopupWindowState();
}

class _BookingPopupWindowState extends State<BookingPopupWindow> {
  DateTime selectedDateAndTime = DateTime.now();
  var selectedDate = DateFormat('dd-MM-yyyy');
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController ctrlName = TextEditingController();
  TextEditingController ctrlSurname = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPhone = TextEditingController();
  int counterPeople = 0;
  final List<double> bookingTimeList = [0.5, 1, 1.5, 2, 2.5, 3];
  double bookedTime = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: notifire!.getcontiner,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          elevation: 0,
          content: SingleChildScrollView(
            child: SizedBox(
              height: 600,
              width: 850,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 540,
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.tableDetailedData.imageUrl),
                                    fit: BoxFit.contain)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 540,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/times.svg",
                                          colorFilter: const ColorFilter.mode(
                                              Colors.grey, BlendMode.srcIn),
                                          width: 18,
                                          height: 18,
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 55,
                                ),
                                Text(
                                  "Sala: ${widget.tableDetailedData.roomName}",
                                  style: TextStyle(
                                      color: notifire!.getMainText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Typ stolika: ${tableTypeDecoder(widget.tableDetailedData.tableType)}",
                                  style: TextStyle(
                                      color: notifire!.getMainText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Max. liczba osób: ${widget.tableDetailedData.maxPeople}",
                                  style: TextStyle(
                                      color: notifire!.getMainText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _calendarRow(
                                        title: 'Data rezerwacji',
                                        text: selectedDate
                                            .format(selectedDateAndTime),
                                        icon: 'svg/calendar.svg',
                                        ontap: () {
                                          _selectDateAndTime();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: _calendarRow(
                                        title: 'Czas rezerwacji',
                                        text: selectedTime.format(context),
                                        icon: 'svg/clock_empty.svg',
                                        ontap: () {
                                          _selectTime();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: buildTextFilde(
                                        numberOnly: false,
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
                                        numberOnly: false,
                                        controller: ctrlSurname,
                                        hinttext: "Nazwisko",
                                        prefixicon: "svg/user.svg",
                                        suffixistrue: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: buildTextFilde(
                                        numberOnly: false,
                                        controller: ctrlEmail,
                                        hinttext: "Adres e-mail",
                                        prefixicon: "svg/at.svg",
                                        suffixistrue: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: buildTextFilde(
                                        numberOnly: true,
                                        controller: ctrlPhone,
                                        hinttext: "Telefon",
                                        prefixicon: "svg/phone.svg",
                                        suffixistrue: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Wybierz ilość miejsc",
                                            style: TextStyle(
                                                color: notifire!.getMainText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        _counterButton(),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Określ długość",
                                            style: TextStyle(
                                                color: notifire!.getMainText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: DropdownButtonFormField2<
                                                String>(
                                              style:
                                                  mediumBlackTextStyle.copyWith(
                                                      color: notifire!
                                                          .getMainText),
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              hint: Text(
                                                'Długość rezerwacji',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: notifire
                                                        ?.getbacktextcolors,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              items: bookingTimeList
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item.toString(),
                                                        child: Text(
                                                          "${item.toString()}h",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Proszę określ czas rezerwacji';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                bookedTime = double.parse(
                                                    value.toString());
                                              },
                                              onSaved: (value) {
                                                bookedTime = double.parse(
                                                    value.toString());
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: notifire!
                                                      .getbacktextcolors,
                                                ),
                                                iconSize: 24,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  color: notifire!.getcontiner,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _confirmButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String tableTypeDecoder(String type) {
    switch (type) {
      case 'squareTable':
        return 'Kwadratowy';
      case 'rectangularTable':
        return 'Prostokątny';
      case 'rectangularLongTable':
        return 'Prostokątny (długi)';
      case 'roundTable':
        return 'Okrągły';
      default:
        return 'Brak danych';
    }
  }

  Widget buildTextFilde(
      {required String hinttext,
      required String prefixicon,
      required TextEditingController controller,
      required bool numberOnly,
      required bool suffixistrue}) {
    return TextFormField(
      keyboardType: numberOnly ? TextInputType.number : null,
      inputFormatters: numberOnly
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole jest wymagane';
        }
        return null;
      },
      controller: controller,
      style: TextStyle(color: notifire!.getMainText),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: notifire!.isDark
                    ? notifire!.geticoncolor
                    : Colors.grey.shade200)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: notifire!.isDark
                    ? notifire!.geticoncolor
                    : Colors.grey.shade200)),
        hintText: hinttext,
        hintStyle: mediumGreyTextStyle,
        prefixIcon: SizedBox(
          height: 20,
          width: 50,
          child: Center(
              child: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(notifire!.geticoncolor, BlendMode.srcIn),
            prefixicon,
            height: 18,
            width: 18,
          )),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      cancelText: 'Anuluj',
      confirmText: 'Zatwierdź',
      helpText: 'Określ czas',
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      cancelText: 'Anuluj',
      confirmText: 'Zatwierdź',
      helpText: 'Wybierz datę',
      context: context,
      initialDate: selectedDateAndTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != selectedDateAndTime) {
      setState(() {
        selectedDateAndTime = pickedDate;
      });
    }
  }

  Widget _calendarRow(
      {required String title,
      required String text,
      required String icon,
      void Function()? ontap}) {
    return Column(
      children: [
        SizedBox(
            height: 32,
            child: Center(
                child: Text(
              title,
              style: mediumBlackTextStyle.copyWith(
                  color: notifire!.getMainText, fontSize: 15),
            ))),
        GestureDetector(
          onTap: ontap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade200)),
            child: Center(
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title:
                    Text(text, style: TextStyle(color: notifire!.getMainText)),
                leading: SvgPicture.asset(icon,
                    colorFilter: ColorFilter.mode(
                        notifire!.getMainText, BlendMode.srcIn)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _counterButton() {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer<ColorProvider>(
        builder: (context, value, child) => Container(
          height: 35,
          width: 120,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: notifire!.getbordercolor,
              borderRadius: BorderRadius.circular(14)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
                onTap: () {
                  setState(() {
                    if (counterPeople > 0) {
                      counterPeople--;
                    }
                  });
                },
                child: Image.asset("assets/ic_minus_top.png")),
            Text("$counterPeople",
                style: mediumBlackTextStyle.copyWith(
                    fontSize: 18, color: notifire!.getMainText)),
            InkWell(
                onTap: () {
                  setState(() {
                    counterPeople++;
                  });
                },
                child: Image.asset("assets/ic_plus_top.png")),
          ]),
        ),
      );
    });
  }

  Widget _confirmButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(42),
              backgroundColor: Colors.white,
            ),
            child: Text(
              "Anuluj",
              style: mediumBlackTextStyle.copyWith(
                  color: appMainColor, fontWeight: FontWeight.w200),
            )),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                await widget.organizationReference
                    .collection("reservations")
                    .add({
                  'name': ctrlName.text,
                  'createdTime': DateTime.now().toUtc(),
                  'surname': ctrlSurname.text,
                  'email': ctrlEmail.text,
                  'phone': ctrlPhone.text,
                  'peopleNumber': counterPeople,
                  'roomName': widget.tableDetailedData.roomName,
                  'tableNo': widget.tableDetailedData.tableNo,
                  'bookedTime': bookedTime,
                  'bookingTime': Timestamp.fromDate(DateTime(
                      selectedDateAndTime.year,
                      selectedDateAndTime.month,
                      selectedDateAndTime.day,
                      selectedTime.hour,
                      selectedTime.minute)),
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pomyślnie utworzono rezerwację.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Coś poszło nie tak. Spróbuj ponownie później.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(42),
              backgroundColor: appMainColor,
            ),
            child: Text(
              "Zarezerwuj",
              style: mediumBlackTextStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w200),
            )),
      ],
    );
  }
}
