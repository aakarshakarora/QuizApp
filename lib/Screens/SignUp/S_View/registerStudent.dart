import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Login/loginScreen.dart';
import 'package:quiz_app/Theme/components/already_have_an_account_acheck.dart';
import 'package:quiz_app/Theme/components/backgroundRegister.dart';
import 'package:quiz_app/Theme/theme.dart';

class StudentRegister extends StatefulWidget {
  StudentRegister({Key key}) : super(key: key);

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String role = "Student";
  bool showSpinner = false;

  TextEditingController studentNameController = new TextEditingController();
  TextEditingController emailIdInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController confirmPwdInputController = new TextEditingController();

  TextEditingController contactNumberInputController =
      new TextEditingController();

  TextEditingController courseNameController = new TextEditingController();

  TextEditingController registrationNoController = new TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  //Send Email Verification Code on Registered Email ID
  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  //Check if Field is Empty or not
  // ignore: missing_return
  String checkEmpty(String value) {
    if (value.isEmpty) {
      setState(() {
        showSpinner = false;
      });
      return 'Field Required';
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register as Student",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 20)),
        centerTitle: true,
      ),
      body: BackgroundRegister(
        check: true,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Student Name',
                    ),
                    textCapitalization: TextCapitalization.words,
                    controller: studentNameController,
                    // ignore: missing_return
                    validator: (value) {},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Student Email ID',
                    ),
                    controller: emailIdInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText1
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                    ),
                    controller: pwdInputController,
                    obscureText: _obscureText1,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                    ),
                    controller: confirmPwdInputController,
                    obscureText: _obscureText2,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Column(
                    children: [
                      Text(
                        "User Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Student Contact Number',
                        ),
                        controller: contactNumberInputController,
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Registration Number',
                        ),
                        controller: registrationNoController,
                        keyboardType: TextInputType.phone,
                        //validator: ,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Course Name',
                        ),
                        controller: courseNameController,
                        keyboardType: TextInputType.text,
                        // validator: validateMobile,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Poppins'),
                    ),
                    color: Colors.purple,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailIdInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => FirebaseFirestore.instance
                                  .collection("Student")
                                  .doc(currentUser.user.uid)
                                  .set({
                                    "UserID": currentUser.user.uid,
                                    "S_Name": studentNameController.text,
                                    "Role": role,
                                    "S_EmailId": emailIdInputController.text,
                                    "S_ContactNumber":
                                        contactNumberInputController.text,
                                    "S_Course": courseNameController.text,
                                    "S_RegNo": registrationNoController.text,
                                    "GroupAdded": FieldValue.arrayUnion([]),
                                    "QuizGiven": FieldValue.arrayUnion([]),
                                  })
                                  .then((result) => {
                                        sendEmailVerification(),
                                        FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(currentUser.user.uid)
                                            .set({
                                          'U_Name': studentNameController.text
                                              .toUpperCase(),
                                          'Role': role,
                                          "UserID": currentUser.user.uid,
                                        }),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                            (_) => false),
                                        emailIdInputController.clear(),
                                        pwdInputController.clear(),
                                        confirmPwdInputController.clear(),
                                        contactNumberInputController.clear(),
                                        studentNameController.clear(),
                                        courseNameController.clear(),
                                        registrationNoController.clear()
                                      })
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("The passwords do not match"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 18,
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
          ),
        ),
      ),
    );
  }
}
