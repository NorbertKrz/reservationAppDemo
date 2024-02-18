import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalData {
  final String name;
  final String surname;

  PersonalData({
    required this.name,
    required this.surname,
  });
}

class AccountData {
  final Plan plan;
  final Timestamp createdTime;
  final Timestamp expirationDate;

  AccountData({
    required this.plan,
    required this.createdTime,
    required this.expirationDate,
  });
}

class UserModel {
  final String id;
  final String email;
  final PersonalData? personalData;
  final AccountData? accountData;
  final Role? role;
  late final DocumentReference? organizationRef;

  UserModel({
    required this.email,
    required this.id,
    this.personalData,
    this.accountData,
    this.role,
    this.organizationRef,
  });

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email!,
    );
  }

  factory UserModel.addData(
    UserModel user,
    String id,
    String email,
    PersonalData? personalData,
    AccountData? accountData,
    Role? role,
    DocumentReference? organizationRef,
  ) {
    return UserModel(
      email: user.email,
      id: user.id,
      personalData: personalData,
      accountData: accountData,
      role: role,
      organizationRef: organizationRef,
    );
  }
}
