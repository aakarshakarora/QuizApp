import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/Theme/components/fadeAnimation.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: darkerBlue,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
              0.75,
              SvgPicture.asset(
                "assets/icons/splash.svg",
                height: size.height * 0.35,
              ),
            ),
            Text("Please Wait..."),
            Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>( Color(0xff631aaf)),
                strokeWidth: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
