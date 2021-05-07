import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Welcome/welcomeScreen.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/Theme/components/rounded_button.dart';

class NotVerified extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/verify.jpg"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your Email ID is not Verified !! "),
              Icon(
                Icons.not_interested,
                color: Colors.red,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Click \"Get Link\" to receive Verification link on your Email ID  ",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5),
          RoundedButton(
            text: "Get Link",
            press: () {
              sendEmailVerification();
              _displaySnackBar(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomeScreen();
                  },
                ),
              );
            },
          ),
          Text("Verify your Email ID to Login"),
        ]),
      ),
    );
  }

  Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Link Sent on ' + FirebaseAuth.instance.currentUser.email,
      style: TextStyle(fontFamily: 'Poppins'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
