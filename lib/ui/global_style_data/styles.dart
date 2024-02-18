import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/ui/provider/color_provider.dart';

//..............Colors....................

const Color appBgColor = Color(0xfff3f4f7);
const Color appMainColor = Color(0xff0059E7);
const Color appWhiteColor = Color(0xffffffff);
const Color appGreyColor = Color(0xffa1a1ae);
const Color appPurpleColor = Color(0xff7366ff);
const Color appPinkColor = Color(0xfff73164);
const Color appGreenColor = Color(0xff54ba4a);
const Color appLihtBlueColor = Color(0xff16c7f9);
const Color appOrangeColor = Color(0xffffaa05);
const Color appRedColor = Color(0xfffc4438);
const Color appLightGreyColor = Color(0xfff7f6ff);
const Color tableColor = Color(0xFF2446a1);

//..............TextStyle....................

TextStyle mainTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.black,
    fontFamily: "Gilroy");
TextStyle mediumGreyTextStyle =
    const TextStyle(fontSize: 14, color: appGreyColor, fontFamily: "Gilroy");
TextStyle mediumBlackTextStyle =
    const TextStyle(fontSize: 14, color: Colors.black, fontFamily: "Gilroy");

//..............BoxShadow....................

List<BoxShadow>? boxShadow = [];

Decoration boxDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  color: notifire!.getcontiner,
  boxShadow: boxShadow,
);

//..............Listeners....................

final ValueNotifier<DocumentReference?> orgRefListener =
    ValueNotifier<DocumentReference?>(null);

//const value

const double padding = 15;

// *****************************************
ColorProvider? notifire;
