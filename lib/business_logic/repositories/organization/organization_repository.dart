import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';

class OrganizationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<OrganizationModel> streamOrganization(
      {required DocumentReference orgRef}) async* {
    yield* orgRef.snapshots().asyncMap((value) async {
      List<Booking> reservationList = [];

      await orgRef.collection('reservations').get().then((value) async {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            var data = element.data();
            reservationList.add(Booking(
                name: data['name'] ?? 'Brak danych',
                surname: data['surname'] ?? 'Brak danych',
                email: data['email'] ?? 'Brak danych',
                phone: data['phone'] ?? 'Brak danych',
                peopleNumber: data['peopleNumber'] ?? 0,
                tableNo: data['tableNo'] ?? 0,
                bookedTime: data['bookedTime'] ?? 0,
                createdTime: data['createdTime'] ?? Timestamp(0, 0),
                bookingTime: data['bookingTime'] ?? Timestamp(0, 0)));
            debugPrint('Kolekcja "reservations" istnieje');
          }
        } else {
          reservationList = [];
          debugPrint('Kolekcja "reservations" nie istnieje');
        }
      });

      return OrganizationModel.fromFirestore(
          value.reference, value.data()!, reservationList);
    });
  }

  Stream<List<OrganizationModel>> streamSpolkeAdmin() async* {
    yield* _db
        .collection('organizations')
        .snapshots()
        .asyncMap((QuerySnapshot spolki) async {
      List<OrganizationModel> spolkiLista = <OrganizationModel>[];
      List<DocumentSnapshot> dokumenty = spolki.docs.cast<DocumentSnapshot>();

      for (DocumentSnapshot dokument in dokumenty) {
        DocumentReference docRef = dokument.reference;
        // String id =
        //     await dokument.reference.collection('reservations').get().then(
        //           (value) {
        //             if (value.docs.isNotEmpty) {
        //               return value.docs.first.id;
        //             } else {
        //               return '';
        //             }
        //           },
        //         ) ??
        //         '';
        // Map daneO = {};
        // if (id.isNotEmpty) {
        //   daneO = await dokument.reference
        //       .collection('reservations')
        //       .doc(id)
        //       .get()
        //       .then((value) => value.data() as Map);
        // } else {
        //   daneO = {};
        // }

        spolkiLista.add(OrganizationModel.fromFirestore(docRef, {}, []));
      }
      return spolkiLista;
    });
  }
}

class Booking {
  final String name;
  final String surname;
  final String email;
  final String phone;
  final num peopleNumber;
  final num tableNo;
  final num bookedTime;
  final Timestamp createdTime;
  final Timestamp bookingTime;

  Booking({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.peopleNumber,
    required this.tableNo,
    required this.bookedTime,
    required this.createdTime,
    required this.bookingTime,
  });
}
