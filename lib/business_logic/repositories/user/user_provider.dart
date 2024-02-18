import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/business_logic/models/user_model.dart';

abstract class UserProvider {
  Future<void> initialize();
  UserModel? get currentUser;
  Future<String> get role;
  Future<UserModel> logIn({
    required String email,
    required String password,
  });
  Future<UserModel> createUser({
    required String email,
    required String password,
    required String name,
    required String surName,
  });
  Future<void> logOut();
  Stream<User?> initUserState();
}
