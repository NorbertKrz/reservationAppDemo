import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/business_logic/bloc/organization/organization_bloc.dart';
import 'package:reservation_app/business_logic/bloc/user/user_bloc.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:reservation_app/ui/global_style_data/styles.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/ui/user_profile/components/user_profile_list_tile.dart';

class UserProfileData extends StatefulWidget {
  final int count;
  final bool isMobile;
  const UserProfileData(
      {super.key, required this.count, required this.isMobile});

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData>
    with SingleTickerProviderStateMixin {
  ColorProvider notifire = ColorProvider();
  late DocumentReference orgRef;
  String userId = '';
  String email = '';
  String name = '';
  String surname = '';
  String restaurantName = '';
  String restaurantAddress = '';
  String city = '';
  Plan plan = Plan.basic;
  Role role = Role.viewer;
  Timestamp createdTime = Timestamp(0, 0);
  Timestamp expirationDate = Timestamp(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorProvider>(context, listen: true);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          email = state.user.email;
          name = state.user.personalData!.name;
          surname = state.user.personalData!.surname;
          plan = state.user.accountData!.plan;
          role = state.user.role!;
          createdTime = state.user.accountData!.createdTime;
          expirationDate = state.user.accountData!.expirationDate;
          userId = state.user.id;
          orgRef = state.user.organizationRef!;
        }
        return BlocBuilder<OrganizationBloc, OrganizationState>(
          builder: (context, state) {
            if (state is OrganizationPobrane) {
              OrganizationModel orgData = state.organization
                  .firstWhere((element) => element.ref == orgRef);
              city = orgData.general.city;
              restaurantName = orgData.general.name;
              restaurantAddress = orgData.general.streetNumber;
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // height: 200,
                        padding: EdgeInsets.all(widget.isMobile ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.isMobile ? 10 : padding),
                              child: Text(
                                "Dane dotyczące konta",
                                style: mediumGreyTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.isMobile ? 10 : padding),
                              child: Column(
                                children: [
                                  UserProfileListTile(
                                      title: "Imię: ",
                                      icon: "svg/user.svg",
                                      subtitle: name),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  UserProfileListTile(
                                      title: "Nazwisko: ",
                                      icon: "svg/user.svg",
                                      subtitle: surname),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  UserProfileListTile(
                                      title: "Email: ",
                                      icon: "svg/at.svg",
                                      subtitle: email),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  UserProfileListTile(
                                      title: "Data utworzenia: ",
                                      icon: "svg/clock_empty.svg",
                                      subtitle:
                                          "${createdTime.toDate().day.toString()}.${createdTime.toDate().month.toString()}.${createdTime.toDate().year.toString()}"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 45,
                            ),
                            Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    resetPassword(email: email);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff7366ff),
                                      fixedSize: const Size(120, 38)),
                                  child: const Text(
                                    "Zmień hasło",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: OutlinedButton(
                                  onPressed: () {
                                    deleteAccount();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 2.0, color: Color(0xff7366ff)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fixedSize: const Size(120, 38)),
                                  child: const Text(
                                    "Usuń konto",
                                    style: TextStyle(
                                        color: Color(0xff7366ff),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            );
          },
        );
      },
    );
  }

  deleteAccount() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usuwanie konta'),
          actions: [
            OutlinedButton(
              onPressed: () async {
                if (context.mounted) {}
                Navigator.of(context).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                          'Twoje konto zostało usunięte. Mamy nadzieję, że jeszcze do nas wrócisz.')));
                }
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .delete();
                await FirebaseAuth.instance.currentUser!.delete();
                if (context.mounted) {}
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
                child: Text(
                  'Tak, usuń',
                  style: TextStyle(color: Color(0xff7366ff)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff7366ff))),
              child: const Padding(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
                child: Text('Nie, zostaję'),
              ),
            ),
          ],
          content: const SizedBox(
            width: 450,
            height: 120,
            child: Center(
                child:
                    Text("Czy na pewno chcesz nieodwracalnie usunąć konto?")),
          ),
        );
      },
    );
  }

  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              'Na adres $email wysłano wiadomość z linkiem do zmiany hasła.')));
    }
  }
}
