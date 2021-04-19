import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:quiz_app/CreateGroup/S_View/viewGroup.dart';
import 'package:quiz_app/Pages/FuturePage.dart';
import 'package:quiz_app/Screens/MyProfile/S_Profile/profileStudent.dart';
import 'package:quiz_app/Screens/Welcome/welcomeScreen.dart';
import 'package:quiz_app/Theme/theme.dart';
import 'package:quiz_app/ViewResult/S_View/oldResult.dart';
import '../../main.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../GiveQuiz/giveQuiz.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with AutomaticKeepAliveClientMixin {
  String contactNumber = '8837682823';

  void onStateChanged(bool darkModeEnabledValue) {
    setState(() {
      isDarkModeEnabled = darkModeEnabledValue;
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  List<Color> elevationColors = [
    Color(0xff8900FF),
    Color(0xffFF00F7),
    Color(0xffFF9900)
  ];
  List<Color> tileColors = [lightPurple, lightPink, lightOrange];
  final titles = ['Give Quiz', 'Past Quiz Score', 'View Groups'];
  List<CircleAvatar> titleIcon = [
    CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: Icon(
          Icons.event_note,
          size: 30,
          color: Color(0xff8900FF),
        )),
    CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: Icon(
          Icons.update,
          size: 30,
          color: Color(0xffFF00F7),
        )),
    CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: Icon(
          Icons.group,
          size: 30,
          color: Color(0xffFF9900),
        ))
  ];
  //List<Icon> titleIcon = [Icon(Icons.event_note),Icon(Icons.event_note),Icon(Icons.event_note)];
  final String currentUser=FirebaseAuth.instance.currentUser.uid;
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            "assets/images/main_top.png",
            width: MediaQuery.of(context).size.width * 0.35,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            "assets/images/login_bottom.png",
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ),
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Student')
                .doc(currentUser)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data = snapshot.data.data();
              return Scaffold(
                backgroundColor: Colors.white.withOpacity(0.3),
                // drawer: new Drawer(
                //   child: new ListView(
                //     children: <Widget>[
                //       new UserAccountsDrawerHeader(
                //         accountName: new Text(
                //           'Welcome ${data['S_Name']}',
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 20),
                //         ),
                //         accountEmail: new Text('${data['S_EmailId']}',
                //             style: TextStyle(
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.bold,
                //                 fontFamily: 'Poppins')),
                //         decoration: new BoxDecoration(
                //           image: new DecorationImage(
                //             image: new NetworkImage(
                //                 'https://mdbootstrap.com/img/new/slides/006.jpg'),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         currentAccountPicture: CircleAvatar(
                //             backgroundImage: NetworkImage(
                //                 "https://randomuser.me/api/portraits/lego/1.jpg")),
                //       ),
                //       new ListTile(
                //         leading: Icon(Icons.account_circle),
                //         title: new Text(
                //           "My Profile",
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 17),
                //         ),
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => StudentProfile()),
                //           );
                //         },
                //       ),
                //       new ListTile(
                //         leading: Icon(Icons.notifications_active),
                //         title: new Text(
                //           "Notifications",
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 17),
                //         ),
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(builder: (context) => FuturePage()),
                //           );
                //         },
                //       ),
                //       new ListTile(
                //           leading: Icon(Icons.contact_phone),
                //           title: new Text(
                //             "Contact Us",
                //             style: TextStyle(
                //                 fontFamily: 'Poppins',
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 17),
                //           ),
                //           onTap: () {
                //             createAlertDialog(context, data['F_Name']);
                //             //Navigator.pop(context);
                //           }),
                //       new ListTile(
                //         leading: Icon(Icons.report_problem),
                //         title: new Text(
                //           "Register Complaint",
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 17),
                //         ),
                //         onTap: () {
                //           sendComplaintMail(
                //             data['S_Name'],
                //             currentUser,
                //           );
                //         },
                //       ),
                //       new ListTile(
                //         leading: Icon(Icons.settings),
                //         title: new Text(
                //           "Settings",
                //           style: TextStyle(
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 17),
                //         ),
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(builder: (context) => FuturePage()),
                //           );
                //         },
                //       ),
                //       new Divider(),
                //       new ListTile(
                //           leading: Icon(Icons.power_settings_new),
                //           title: new Text(
                //             "Logout",
                //             style: TextStyle(
                //                 fontFamily: 'Poppins',
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 17),
                //           ),
                //           onTap: () {
                //             signOut();
                //             Navigator.of(context, rootNavigator: true)
                //                 .pushReplacement(MaterialPageRoute(
                //                     builder: (context) => WelcomeScreen()));
                //           }),
                //     ],
                //   ),
                // ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(35),
                            ),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://randomuser.me/api/portraits/lego/5.jpg"),
                                            radius: 30,
                                          ),
                                          Text('Welcome, \n${data['S_Name']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 25)),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          signOut();
                                          Navigator.of(context,
                                              rootNavigator: true)
                                              .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WelcomeScreen()));
                                        },
                                        icon: Icon(Icons.logout),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DayNightSwitcher(
                                        isDarkModeEnabled: isDarkModeEnabled,
                                        onStateChanged: onStateChanged,
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.account_circle,size: 35,),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentProfile()),
                                            );
                                          }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8, right: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(35),
                          ),
                        ),
                        child: Expanded(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: titles.length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: InkWell(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Card(
                                        color: tileColors[index],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        //color: Theme.of(context).primaryColor,
                                        child: Container(
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              titles[index],
                                              style: TextStyle(
                                                  color: elevationColors[
                                                  index],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: -15,
                                          right: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.7,
                                          child: Material(
                                              shape: CircleBorder(),
                                              elevation: 5,
                                              child: titleIcon[index])),
                                    ],
                                  ),
                                  onTap: () {
                                    if (index == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EnterCode()),
                                      );
                                    }

                                    if (index == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewGroups()),
                                      );
                                    }

                                    if (index == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OldResult()),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _recipientController = TextEditingController(
    text: 'info@quizApp.com',
  );

  Future<void> sendComplaintMail(String userName, userId) async {
    final Email email = Email(
      body: "Greetings of the Day!!\n" +
          "I " +
          userName +
          " User ID:" +
          userId +
          "\n would like to register my complain " +
          " \n Thanks,\n" +
          userName,
      subject: "Issue in App " + userName,
      recipients: [_recipientController.text],
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  createAlertDialog(BuildContext context, String userName) {
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            children: [
              AlertDialog(
                title: Center(
                  child: Text(
                    "Contact Us",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Container(
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Call us between 9 AM to 7PM \n\t\t Friday Closed",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 17),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: MaterialButton(
                          onPressed: () {
                            _makePhoneCall('tel:$contactNumber');
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                contactNumber,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Poppins',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: MaterialButton(
                          onPressed: () {
                            emailContact(userName, currentUser);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Text(
                                "E-Mail",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Poppins',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> emailContact(String userName, String userId) async {
    final Email email = Email(
      body: "Greetings of the Day!!\n" +
          "I " +
          userName +
          " User ID:" +
          userId +
          "\n would like to bring your attention to\n------ Insert text here--------- " +
          " \n Thanks,\n" +
          userName,
      //subject: "Service Complain " + userName,
      recipients: [_recipientController.text],
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }
}

signOut() {
  FirebaseAuth.instance.signOut();
}
