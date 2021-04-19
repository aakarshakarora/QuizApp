import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quiz_app/Screens/SignUp/signUpScreen.dart';
import 'package:quiz_app/Screens/SplashScreen/splash.dart';
import 'package:quiz_app/Theme/components/already_have_an_account_acheck.dart';
import 'package:quiz_app/Theme/components/fadeAnimation.dart';
import 'package:quiz_app/Theme/components/text_field_container.dart';
import 'package:quiz_app/Theme/theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool _obscureText = true;
  bool showSpinner = false;
  String _error;

  //Shows Error Displayed from Console
  Widget _buildError() {
    setState(() {
      showSpinner = false;
    });
    if (_error != null) {
      return Container(
          padding: EdgeInsets.all(10),
          color: Colors.yellowAccent,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.error),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(_error, overflow: TextOverflow.clip),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    },
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(child: _buildError()),
              Container(
                padding: EdgeInsets.all(50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Login in Quizzle",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 20),
                      ),
                      SizedBox(height: size.height * 0.03),
                      FadeAnimation(
                        1.0,
                        SvgPicture.asset(
                          "assets/icons/login.svg",
                          height: size.height * 0.35,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFieldContainer(
                        child: TextFormField(
                          cursorColor: kPrimaryColor,
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Email ID",
                            suffixIcon: IconButton(
                              color: kPrimaryColor,
                              icon: Icon(Icons.account_circle_sharp),
                              onPressed: () {},
                            ),
                          ),
                          autofocus: false,
                          validator: (String value) {
                            if (value.isEmpty) {
                              setState(() {
                                showSpinner = false;
                              });
                              return 'Field Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextFieldContainer(
                        child: TextFormField(
                          cursorColor: kPrimaryColor,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Password",
                            suffixIcon: IconButton(
                              color: kPrimaryColor,
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          autofocus: false,
                          obscureText: _obscureText,
                          validator: (String value) {
                            if (value.isEmpty) {
                              setState(() {
                                showSpinner = false;
                              });
                              return 'Field Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: violet,
                          ),
                          child: MaterialButton(
                            textColor: white,
                            padding: EdgeInsets.all(10.0),
                            splashColor: violet,
                            onPressed: () async {
                              await Future.value(_error);
                              setState(() {
                                if (_error != null) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                }
                              });
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              _signInWithEmailAndPassword();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully signed in ' + _userEmail
                                  : 'Sign in failed'),
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      AlreadyHaveAnAccountCheck(
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    print("SignIn is called");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return SplashScreen(
                text: "Logging You In....",
              );
            }),
          );
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _error = e.message;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
