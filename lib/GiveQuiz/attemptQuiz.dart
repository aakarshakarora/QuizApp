import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/Pages/FuturePage.dart';
import 'package:quiz_app/Utilities/buttons.dart';
import 'package:quiz_app/ViewResult/S_View/postQuiz.dart';

import 'globals.dart' as global;

class AttemptQuiz extends StatefulWidget {
  final String subjectName, accessCode;
  final int questionCount, maximumScore;
  final int timeCount;

  AttemptQuiz(
      {@required this.accessCode,
      @required this.subjectName,
      @required this.questionCount,
      @required this.maximumScore,
      @required this.timeCount});

  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uId, subjectName, creatorName, maxScore, quizDate;
  dynamic finalScore;

  String getUserID() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    print(uid);
    return uid.toString();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  int pause = 0, resume = 0, inactive = 0, dead = 0;

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    uId = getUserID();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    secureScreen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
          print('paused state');
          pause++;
          print(pause);
          break;
        case AppLifecycleState.resumed:
          print('resumed state');
          resume++;
          print(resume);
          break;
        case AppLifecycleState.inactive:
          print('inactive state');
          inactive++;
          print(inactive);
          FirebaseFirestore.instance
              .collection('Quiz')
              .doc(widget.accessCode)
              .collection(widget.accessCode + 'Result')
              .doc(uId)
              .update({
            "S_UID": uId,
            "Score": finalScore.toString(),
            'tabSwitch': inactive
          }).then((_) {
            //_displaySnackBar(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostQuiz(finalScore, inactive)),
            );
          });
          break;
        case AppLifecycleState.detached:
          print('suspending state');
          dead++;
          print(dead);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (global.attempted.isEmpty && global.correct.isEmpty) {
      global.attempted = List.filled(widget.questionCount, 0);
      global.correct = List.filled(widget.questionCount, 0);
    }
    var firestoreDB = FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .collection(widget.accessCode)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: Column(
        children: [
          CountdownTimer(
            endTime: widget.timeCount,
            widgetBuilder: (_, CurrentRemainingTime time) {
              if (time == null) {
                FirebaseFirestore.instance
                    .collection('Quiz')
                    .doc(widget.accessCode)
                    .collection(widget.accessCode + 'Result')
                    .doc(uId)
                    .update({
                  "S_UID": uId,
                  "Score": finalScore.toString(),
                  'tabSwitch': inactive
                }).then((_) {
                  //_displaySnackBar(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostQuiz(finalScore, inactive)),
                  );
                });
              }
              return Text(' ${time.hours} : ${time.min} :  ${time.sec}');
            },
          ),

          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: firestoreDB,
                builder: (ctx, opSnapshot) {
                  if (opSnapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final reqDocs = opSnapshot.data.documents..shuffle();
                  print('length ${reqDocs.length}');
                  return PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reqDocs.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: (BorderRadius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuestionTile(
                              index: index,
                              reqDoc: reqDocs[index],
                              correctAnswerMarks:
                                  (widget.maximumScore) / (reqDocs.length),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                index == 0
                                    ? Container()
                                    : roundedButton(
                                        color: Colors.blue,
                                        context: context,
                                        text: "Prev",
                                        onPressed: () {
                                          print("Prev Button is pressed!");
                                          print(index);
                                          print(widget.questionCount);
                                          pageController.animateToPage(
                                              index - 1,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.easeIn);
                                        }),
                                index != widget.questionCount - 1
                                    ? roundedButton(
                                        color: Colors.blue,
                                        context: context,
                                        text: "Next",
                                        onPressed: () {
                                          print("Next Button is pressed!");
                                          print(index);
                                          print(widget.questionCount);
                                          pageController.animateToPage(
                                              index + 1,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.bounceInOut);
                                        })
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: 20),
                            roundedButton(
                                color: Colors.orange,
                                context: context,
                                text: "Submit",
                                onPressed: () {
                                  print("Submit Button is pressed!");

                                  print(
                                      "Total Score:${(global.correct.reduce((a, b) => a + b)) * (widget.maximumScore) / (reqDocs.length)}");

                                  setState(() {
                                    finalScore = ({
                                      (global.correct.reduce((a, b) => a + b)) *
                                          (widget.maximumScore) /
                                          (reqDocs.length)
                                    });
                                  });
                                  FirebaseFirestore.instance
                                      .collection('Quiz')
                                      .doc(widget.accessCode)
                                      .collection(widget.accessCode + 'Result')
                                      .doc(uId)
                                      .update({
                                    "S_UID": uId,
                                    "Score": finalScore.toString(),
                                    'tabSwitch': inactive
                                  }).then((_) {
                                    //_displaySnackBar(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostQuiz(finalScore, inactive)),
                                    );
                                  });
                                }),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionTile extends StatefulWidget {
  // TODO:defined totalDocs
  final dynamic reqDoc, index, correctAnswerMarks;

  QuestionTile(
      {@required this.reqDoc,
      @required this.index,
      @required this.correctAnswerMarks});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile>
    with AutomaticKeepAliveClientMixin {
  String selectedValue, correctOption;

  List<String> options = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    options = [
      widget.reqDoc.get("01"),
      widget.reqDoc.get("02"),
      widget.reqDoc.get("03"),
      widget.reqDoc.get("04"),
    ];
    options.shuffle();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    secureScreen();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Q${widget.index + 1} ${widget.reqDoc.get("Ques")}"),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (ctx, index) {
                return Row(
                  children: [
                    Radio(
                        value: options[index],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            // TODO: added attempted functionality
                            selectedValue = value;
                            global.attempted[widget.index] = 1;
                            // Provider.of<Data>(context, listen: false)
                            //     .changeCount(
                            //         global.attempted.reduce((a, b) => a + b));
                          });
                          print("Option Selected: ${options[index]}");
                          if (options[index] == widget.reqDoc.get("01")) {
                            print("Correct answer!");
                            setState(() {
                              global.correct[widget.index] = 1;
                            });
                          } else {
                            print("Wrong answer");
                            setState(() {
                              global.correct[widget.index] = 0;
                            });
                          }

                          print("Questions attempted: ${global.attempted}");
                          print(global.attempted.reduce((a, b) => a + b));
                          print("Questions correct: ${global.correct}");
                          // print(
                          //     "Total Score:${(global.correct.reduce((a,
                          //         b) => a + b)) * widget.correctAnswerMarks}");
                        }),
                    Text(options[index]),
                  ],
                );
              }),
        ],
      ),
    );
  }
}