import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/Common/facultyBar.dart';
import 'package:quiz_app/Common/studentBar.dart';
import 'package:quiz_app/Screens/SplashScreen/authHelper.dart';
import 'package:quiz_app/Screens/SplashScreen/splash.dart';
import 'package:quiz_app/Screens/Welcome/welcomeScreen.dart';

class RoleCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc.data();
                  if (user['Role'] == 'Student') {
                    return StudentBar();
                  } else if (user['Role'] == 'Faculty') {
                    return FacultyBar();
                  } else {
                    return WelcomeScreen();
                  }
                } else {
                  return Material(
                    child: SplashScreen(),
                  );
                }
              },
            );
          }
          return WelcomeScreen();
        });
  }
}
