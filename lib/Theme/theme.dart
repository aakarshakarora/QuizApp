import 'package:flutter/material.dart';

const Color white = Color(0xfff6f5f8);
const Color violet = Color(0xff631aaf);
const Color pink = Color(0xff93329e);
const Color darkblue = Color(0xff282a92);
const Color lightPurple = Color(0xffEFDEFF);
const Color lightPink = Color(0xffffe3fe);
const Color kPrimaryColor = Color(0xFF6F35A5);
const Color kPrimaryLightColor = Color(0xFFF1E6FF);
const Color orange = Color(0xffFFA500);
const Color lightOrange = Color(0xffFFF0D1);
const Color otherButton = Color(0xff6930c3);

const TextStyle darkSmallTextBold = TextStyle(
    fontSize: 13.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');

const TextStyle darkSmallText =
    TextStyle(fontSize: 13.5, color: Colors.black, fontFamily: 'Poppins');

const kTextFieldDecoration = InputDecoration(
  labelText: '',
  labelStyle: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 17,
      fontFamily: 'Poppins'),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: violet, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: violet, width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kloginScreenButtonStyle = BoxDecoration(
    color: darkblue, borderRadius: BorderRadius.all(Radius.circular(30)));
