import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quiz_app/CreateGroup/S_View/viewGroup.dart';
import 'package:quiz_app/Screens/Welcome/welcomeScreen.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/ViewResult/S_View/oldResult.dart';
import '../../../GiveQuiz/giveQuiz.dart';
import 'package:quiz_app/Theme/theme.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with AutomaticKeepAliveClientMixin {
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

  final String currentUser = FirebaseAuth.instance.currentUser.uid;

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: FutureBuilder<DocumentSnapshot>(
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
              body: Background(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
                        color: Color(0xf07e2ae3),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://randomuser.me/api/portraits/lego/1.jpg"),
                                      radius: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(' Welcome, \n${data['S_Name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
                                  icon: Icon(Icons.logout,
                                      color: Color(0xffeeecf5)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.brightness_medium,
                                    color: Color(0xfff7f1ff),
                                    size: 35,
                                  ),
                                  onPressed:
                                   () {
                                  //
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           StudentProfile()),
                                  // );
                                   }
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.notifications_sharp,
                                      color: Color(0xfff7f1ff),
                                      size: 35,
                                    ),
                                    onPressed:
                                      (){
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           StudentProfile()),
                                      // );
                                    }
                                    ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
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
                                    elevation: 5,
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
                                              color: elevationColors[index],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: -15,
                                      right: MediaQuery.of(context).size.width *
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

                                if (index == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OldResult()),
                                  );
                                }

                                if (index == 2) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewGroups()),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }



}

signOut() {
  FirebaseAuth.instance.signOut();
}
