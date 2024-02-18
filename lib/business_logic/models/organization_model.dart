import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';

class OrganizationModel {
  final DocumentReference ref;
  final List<Booking> reservations;
  final ProcessInfo processInfo;
  final ProjectData projectData;
  final General general;

  OrganizationModel({
    required this.ref,
    required this.reservations,
    required this.processInfo,
    required this.projectData,
    required this.general,
  });

  factory OrganizationModel.fromFirestore(
      DocumentReference orgRef, Object data, List<Booking> reservationsData) {
    Map dane = data as Map;
    DocumentReference ref = orgRef;
    Map generalTemp = dane['general'];
    Map processDataTemp = dane['processData'] ?? {};
    Map projectDataTemp = dane['projectData'] ?? {};

    List roomsListTemp = projectDataTemp['rooms'] ?? [];
    // print("roomsListTemp $roomsListTemp");
    Map tablesMapTemp = projectDataTemp['tablePositions'] ?? {};
    General general = General(
        name: generalTemp['name'] ?? 'Brak danych',
        city: generalTemp['city'] ?? 'Brak danych',
        postCode: generalTemp['postCode'] ?? 'Brak danych',
        streetNumber: generalTemp['streetNumber'] ?? 'Brak danych',
        roomQuantity: generalTemp['roomQuantity'] ?? 0,
        levelQuantity: generalTemp['levelQuantity'] ?? 0,
        details: generalTemp['details'] ?? 'Brak danych',
        openingTimes: generalTemp['openingTimes'] ?? []);
    ProcessInfo processInfo = ProcessInfo(
        createdTime: processDataTemp.isNotEmpty
            ? processDataTemp['createdTime']
            : Timestamp(0, 0),
        status: processDataTemp.isNotEmpty
            ? processDataTemp['creationStatus']['status']
            : 'Brak danych',
        step: processDataTemp.isNotEmpty
            ? processDataTemp['creationStatus']['step']
            : 0);
    //rooms Data
    List<RoomsData> roomsDataList = [];
    if (roomsListTemp.isNotEmpty) {
      for (int i = 0; i < roomsListTemp.length; i++) {
        roomsDataList.add(RoomsData(
            // offsetList: roomOffsets,
            offsetList: roomsListTemp[i]['offsets'] ?? [],
            roomName: roomsListTemp[i]['roomName'] ?? 'Brak danych',
            roomLevel: roomsListTemp[i]['roomLevel'] ?? 0));
      }
    } else {
      roomsDataList = [];
    }

    // table Positions
    List<List<TableDetailedData>> tablePosList = [];
    if (tablesMapTemp.isNotEmpty) {
      for (var element in tablesMapTemp.keys) {
        List<TableDetailedData> temp = [];
        for (var element1 in tablesMapTemp[element]) {
          temp.add(TableDetailedData(
            chairsAtEndsOn: element1['chairsAtEndsOn'] ?? false,
            imageUrl: element1['imageUrl'] ?? false,
            maxPeople: element1['maxPeople'] ?? false,
            offset: Offset(
                element1['offset']['dx'] ?? 0, element1['offset']['dy'] ?? 0),
            roomName: element1['roomName'] ?? false,
            tableNo: element1['tableNo'] ?? false,
            tableSize: element1['tableSize'] ?? false,
            tableType: element1['tableType'] ?? false,
          ));
        }
        tablePosList.add(temp);
      }
    } else {
      tablePosList = [];
    }

    return OrganizationModel(
      ref: ref,
      general: general,
      reservations: reservationsData,
      projectData:
          ProjectData(tablePositions: tablePosList, rooms: roomsDataList),
      processInfo: processInfo,
    );
  }

  List<Object?> get props => [
        ref,
        general,
        reservations,
        projectData,
        processInfo,
      ];
}

class General {
  final String name;
  final String city;
  final String postCode;
  final String streetNumber;
  final int roomQuantity;
  final int levelQuantity;
  final String details;
  final List openingTimes;

  General({
    required this.name,
    required this.city,
    required this.postCode,
    required this.streetNumber,
    required this.roomQuantity,
    required this.levelQuantity,
    required this.details,
    required this.openingTimes,
  });
}

class ProcessInfo {
  final Timestamp createdTime;
  final String status;
  final int step;

  ProcessInfo({
    required this.createdTime,
    required this.status,
    required this.step,
  });
}

class ProjectData {
  final List<List<TableDetailedData>> tablePositions;
  final List<RoomsData> rooms;

  ProjectData({
    required this.tablePositions,
    required this.rooms,
  });
}

class RoomsData {
  final List offsetList;
  final String roomName;
  final num roomLevel;

  RoomsData({
    required this.offsetList,
    required this.roomName,
    required this.roomLevel,
  });
}

class TableDetailedData {
  final bool chairsAtEndsOn;
  final String imageUrl;
  final num maxPeople;
  final Offset offset;
  final String roomName;
  final num tableNo;
  final num tableSize;
  final String tableType;

  TableDetailedData({
    required this.chairsAtEndsOn,
    required this.imageUrl,
    required this.maxPeople,
    required this.offset,
    required this.roomName,
    required this.tableNo,
    required this.tableSize,
    required this.tableType,
  });
}
