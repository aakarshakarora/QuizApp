import 'package:flutter/material.dart';

const Color white = Color(0xfff6f5f8);
const Color buttonColor = Color(0xff631aaf);
const Color darker = Color(0xff93329e);
const Color blue = Color(0xff282a92);
const Color light = Color(0xffb4aee8);
const Color lightest = Color(0xffffe3fe);
const Color kPrimaryColor = Color(0xFF6F35A5);
const Color kPrimaryLightColor = Color(0xFFF1E6FF);
const Color submit = Color(0xfffb743e);
const Color otherButton = Color(0xff6930c3);

const TextStyle requestCardHeading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.red);

const TextStyle kbuttonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: white,
    fontFamily: 'Poppins');

const TextStyle lightHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: white,
    fontFamily: 'PoppinsBold');

const TextStyle lightSmallText =
    TextStyle(fontSize: 18.5, color: white, fontFamily: 'Poppins');

const TextStyle lightTinyText =
    TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'Poppins');

const TextStyle darkHeading = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Poppins');

const TextStyle darkSmallTextBold = TextStyle(
    fontSize: 13.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');

const TextStyle darkSmallText =
    TextStyle(fontSize: 13.5, color: Colors.black, fontFamily: 'Poppins');

const TextStyle greySmallText =
    TextStyle(fontSize: 14, color: Colors.black38, fontFamily: 'Poppins');

const TextStyle darkTinyText =
    TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Poppins');

const TextStyle gridTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: buttonColor,
    fontFamily: 'Poppins');

const kCardTextStyle = TextStyle(
  fontSize: 17,
  fontFamily: 'Poppins',
  color: Colors.black,
);

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
    borderSide: BorderSide(color: buttonColor, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: buttonColor, width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kloginScreenButtonStyle = BoxDecoration(
    color: blue, borderRadius: BorderRadius.all(Radius.circular(30)));
