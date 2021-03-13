import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:quiz_app/Utilities/buttons.dart';
import 'package:quiz_app/ViewResult/S_View/postQuiz.dart';

import 'globals.dart' as global;

class AttemptQuiz extends StatefulWidget {
  final String subjectName, accessCode;
  final int questionCount, maximumScore, timeCount;

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
  bool attempted = true;
  int finalScore = 0;

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
    secureScreen();
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
            "Score": finalScore,
            'tabSwitch': inactive,
            'attempted': attempted,
          }).then((_) {
            //_displaySnackBar(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostQuiz(
                        score: finalScore,
                        inactive: inactive,
                        totalScore: widget.maximumScore,
                      )),
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
                  "Score": finalScore,
                  'tabSwitch': inactive,
                  'attempted': attempted,
                }).then((_) {
                  //_displaySnackBar(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostQuiz(
                              score: finalScore,
                              inactive: inactive,
                              totalScore: widget.maximumScore,
                            )),
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
                      return SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: (BorderRadius.circular(20)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              reqDocs[index].get("imgURL") == null
                                  ? Container()
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                          reqDocs[index].get("imgURL")),
                                    ),
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
                                      finalScore = (global.correct
                                              .reduce((a, b) => a + b)) *
                                          (widget.maximumScore) ~/
                                          (reqDocs.length);
                                    });
                                    FirebaseFirestore.instance
                                        .collection('Quiz')
                                        .doc(widget.accessCode)
                                        .collection(
                                            widget.accessCode + 'Result')
                                        .doc(uId)
                                        .update({
                                      "S_UID": uId,
                                      "Score": finalScore,
                                      'tabSwitch': inactive,
                                      'attempted': attempted,
                                    }).then((_) {
                                      //_displaySnackBar(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostQuiz(
                                                  score: finalScore,
                                                  inactive: inactive,
                                                  totalScore:
                                                      widget.maximumScore,
                                                )),
                                      );
                                      global.attempted = [];
                                      global.correct = [];
                                    });
                                  }),
                            ],
                          ),
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

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    // TODO: implement initState
    options = [
      widget.reqDoc.get("01"),
      widget.reqDoc.get("02"),
      widget.reqDoc.get("03"),
      widget.reqDoc.get("04"),
    ];
    secureScreen();
    options.shuffle();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    secureScreen();
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
                            print(widget.reqDoc.documentID);
                            selectedValue = value;
                            global.attempted[widget.index] = 1;
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
