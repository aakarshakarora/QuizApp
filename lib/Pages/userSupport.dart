import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:quiz_app/Theme/components/fadeAnimation.dart';
import 'package:quiz_app/Theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSupport extends StatefulWidget {
  @override
  _UserSupportState createState() => _UserSupportState();
}

class _UserSupportState extends State<UserSupport> {
  final currentUserID = FirebaseAuth.instance.currentUser.uid;

  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  String contactNumber = '8837682823', emailID = 'support@quizzle.com';

  bool mounted;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendEmail(String uID, String uEmail, String rEmail) async {
    final Email email = Email(
      body: "Greetings of the Day!!\n" +
          "I *" +
          uID +
          "* have registered on Quizzle with  \"" +
          uEmail +
          "\" ID,"
              "\n\n I would like to bring your attention to\n------ Insert text here--------- " +
          " \n\n Thanks,\n",
      subject: "App Service Complain " +
          FirebaseAuth.instance.currentUser.displayName,
      recipients: [rEmail],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Quizzle Support",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            FadeAnimation(
              1.0,
              Image.asset(
                'assets/images/help.jpg',
                //width: size.width * 0.35,
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Pressed");
                sendEmail(currentUserID, currentUserEmail, emailID);
              },
              child: Container(
                padding: EdgeInsets.all(25),
                child: Card(
                  elevation: 5,
                  color: Color(0xff833fee),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                    ),
                  ),

                  //color: Theme.of(context).primaryColor,
                  child: Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Send Complain Mail",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  shadowColor: Color(0xff8d44ff),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "You May also Contact Administrator of your Organisation ",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: otherButton,
        onPressed: () {
          _makePhoneCall('tel:$contactNumber');
        },
        child: Icon(
          Icons.call,
        ),
      ),
    );
  }
}
