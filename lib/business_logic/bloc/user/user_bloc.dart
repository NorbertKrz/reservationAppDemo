import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/business_logic/models/user_model.dart';
import 'package:reservation_app/business_logic/repositories/user/user_provider.dart';
import 'package:reservation_app/tools/enum/plan.dart';
import 'package:reservation_app/tools/enum/role.dart';

part 'user_event.dart';
part 'user_state.dart';

Role roleDecoder(String roleString) {
  switch (roleString) {
    case "superAdmin":
      return Role.superAdmin;
    case "admin":
      return Role.admin;
    case "manager":
      return Role.manager;
    case "user":
      return Role.user;
    case "viewer":
      return Role.viewer;
    default:
      return Role.viewer;
  }
}

Plan planDecoder(String planString) {
  switch (planString) {
    case "basic":
      return Plan.basic;
    case "standard":
      return Plan.standard;
    case "pro":
      return Plan.pro;
    default:
      return Plan.basic;
  }
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserModel? userModel;
  UserBloc(UserProvider provider) : super(const InitialAuthenticationState()) {
    // initialize
    on<AuthInitializeEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else {
        var data = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .get();
        String email;
        String id;
        Role role;
        DocumentReference? orgRef;
        Map accountDataTemp = data['accountData'] ?? {};
        PersonalData personalData = PersonalData(
          name: data.data()!['personalData']['name'] ?? 'Niezdefiniowano',
          surname: data.data()!['personalData']['surname'] ?? 'Niezdefiniowano',
        );
        AccountData accountData = AccountData(
          createdTime: accountDataTemp.isNotEmpty
              ? accountDataTemp['createdTime']
              : Timestamp(0, 0),
          expirationDate: accountDataTemp.isNotEmpty
              ? accountDataTemp['expirationDate']
              : Timestamp(0, 0),
          plan: accountDataTemp.isNotEmpty
              ? planDecoder(accountDataTemp['plan'].toString())
              : Plan.basic,
        );

        String roleString = data.data()!['role'] ?? 'viewer';
        orgRef = data.data()!['organizationRef'];
        email = data.data()!['email'];
        id = data.id;

        role = roleDecoder(roleString);

        userModel = UserModel.addData(
            user, id, email, personalData, accountData, role, orgRef);

        emit(AuthStateLoggedIn(user: userModel!));
      }
    });

    // logging in
    on<AuthLogInEvent>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;

        Role? role;
        String? id;
        DocumentReference? orgRef;
        late PersonalData personalData;
        late AccountData accountData;

        try {
          UserModel user =
              await provider.logIn(email: email, password: password);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .get()
              .then((value) {
            Map accountDataTemp = value['accountData'] ?? {};
            personalData = PersonalData(
              name: value.data()!['personalData']['name'] ?? 'Niezdefiniowano',
              surname:
                  value.data()!['personalData']['surname'] ?? 'Niezdefiniowano',
            );
            accountData = AccountData(
              createdTime: accountDataTemp.isNotEmpty
                  ? accountDataTemp['createdTime']
                  : Timestamp(0, 0),
              expirationDate: accountDataTemp.isNotEmpty
                  ? accountDataTemp['expirationDate']
                  : Timestamp(0, 0),
              plan: accountDataTemp.isNotEmpty
                  ? planDecoder(accountDataTemp['plan'].toString())
                  : Plan.basic,
            );
            id = user.id;
            String roleString = value.data()!['role'] ?? 'viewer';
            role = roleDecoder(roleString);

            orgRef = value.data()!['organizationRef'];
          });

          UserModel userModel = UserModel.addData(
              user, id!, email, personalData, accountData, role, orgRef);

          emit(AuthStateLoggedIn(user: userModel));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );

    on<AuthRegisterEvent>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        final name = event.name;
        final surname = event.surname;
        // final roleString = event.roleString; // Add role to the event properties if needed

        try {
          UserModel user = await provider.createUser(
              email: email, password: password, name: name, surName: surname);

          DateTime now = DateTime.now();
          DateTime nextYear = DateTime(now.year + 1, now.month, now.day);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .set({
            'email': email,
            'role': 'user',
            'personalData': {'name': name, 'surname': surname},
            'accountData': {
              'plan': 'basic',
              'expirationDate': nextYear,
              'createdTime': now,
            }
          }, SetOptions(merge: true));

          FirebaseAuth.instance.currentUser!.sendEmailVerification();

          // emit(AuthStateLoggedIn(user: userModel));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );

    //logging out
    on<AuthLogOutEvent>(
      (event, emit) async {
        emit(const InitialAuthenticationState());
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );
  }
}
