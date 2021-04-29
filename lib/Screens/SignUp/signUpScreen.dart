import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Login/loginScreen.dart';
import 'package:quiz_app/Screens/SignUp/F_View/registerFaculty.dart';
import 'package:quiz_app/Screens/SignUp/S_View/registerStudent.dart';
import 'package:quiz_app/Theme/components/already_have_an_account_acheck.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/Theme/components/fadeAnimation.dart';


class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Sign Up in Quizzle as...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Student Sign Up Request");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return StudentRegister();
                        },
                      ),
                    );
                  },
                  child: FadeAnimation(
                    1.10,
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/stud.jpg",
                          height: 120,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Student"),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Faculty Sign Up Request");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FacultyRegister();
                        },
                      ),
                    );
                  },
                  child: FadeAnimation(
                    1.20,
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/fac.jpg",
                          height: 120,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Faculty"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
