import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/Login/loginScreen.dart';
import 'package:quiz_app/Theme/components/already_have_an_account_acheck.dart';
import 'package:quiz_app/Theme/components/backgroundRegister.dart';
import 'package:quiz_app/Theme/theme.dart';

class FacultyRegister extends StatefulWidget {
  FacultyRegister({Key key}) : super(key: key);

  @override
  _FacultyRegisterState createState() => _FacultyRegisterState();
}

class _FacultyRegisterState extends State<FacultyRegister> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String role = "Faculty";
  bool showSpinner = false;

  TextEditingController facultyNameController = new TextEditingController();
  TextEditingController emailIdInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController confirmPwdInputController = new TextEditingController();

  TextEditingController contactNumberInputController =
  new TextEditingController();

  TextEditingController deptNameController = new TextEditingController();
  TextEditingController empIDController = new TextEditingController();

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
        title: Text("Register as Faculty",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 20)),
        centerTitle: true,
      ),
      body: BackgroundRegister(
        check: false,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'User Name',
                    ),
                    textCapitalization: TextCapitalization.words,
                    controller: facultyNameController,
                    // ignore: missing_return
                    validator: checkEmpty,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'User Email ID',
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
                          labelText: 'Contact Number',
                        ),
                        controller: contactNumberInputController,
                        keyboardType: TextInputType.phone,
                        validator: checkEmpty,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Employee ID',
                        ),
                        controller: empIDController,
                        keyboardType: TextInputType.phone,
                        validator: checkEmpty,
                        //validator: ,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Department Name',
                        ),
                        controller: deptNameController,
                        keyboardType: TextInputType.text,
                        validator: checkEmpty,
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
                              .collection("Faculty")
                              .doc(currentUser.user.uid)
                              .set({
                            "UserID": currentUser.user.uid,
                            "F_Name": facultyNameController.text,
                            "Role": role,
                            "F_EmailId": emailIdInputController.text,
                            "F_ContactNumber":
                            contactNumberInputController.text,
                            "F_EmpID": empIDController.text,
                            "F_DeptNm": deptNameController.text,
                            "QuizCreated":FieldValue.arrayUnion([]),

                          })
                              .then((result) => {
                            sendEmailVerification(),
                            FirebaseFirestore.instance
                                .collection("User")
                                .doc(currentUser.user.uid)
                                . set ({
                              'U_Name':
                              facultyNameController.text.toUpperCase(),
                              'Role': role, "UserID": currentUser.user.uid,

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
                            empIDController.clear(),
                            facultyNameController.clear(),
                            deptNameController.clear(),
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
