import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';

class AttemptQuiz extends StatefulWidget {
  final String subjectName, accessCode;

  AttemptQuiz({@required this.accessCode, @required this.subjectName});

  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> with WidgetsBindingObserver {
//To Implement Tab Switch Check add this line  " with WidgetsBindingObserver"

//Then add code form line 13 to 51
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  int pause = 0, resume = 0, inactive = 0, dead = 0;
  Timestamp sTime, eTime;
  DateTime res1, res2;
  Timer _timer;
  String _timeUntil = "loading...";

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _timeUntil = TimeLeft().timeLeft(res1, res2);
        });
      }
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .get()
        .then((value) {
      sTime = (value.data()['startDate']);
      eTime = (value.data()['endDate']);
      res1 = sTime.toDate();
      res2 = eTime.toDate();
      // countTime= res2.difference(res2).inSeconds;
      print("start " + sTime.toString());
      print("end " + eTime.toString());
      print("result 1" + res2.difference(res1).inSeconds.toString());
    });
    _startTimer();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

 @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();_startTimer();
  }


  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    secureScreen();
    super.dispose();
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard()),
          );
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
    var firestoreDB = FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .collection(widget.accessCode)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: Column(
        children: [
          Text(_timeUntil ?? "loading..."),
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
                  return ListView.builder(
                    itemCount: reqDocs.length,
                    itemBuilder: (ctx, index) {
                      return QuestionTile(
                        index: index,
                        reqDoc: reqDocs[index],
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
  final dynamic reqDoc, index;

  QuestionTile({@required this.reqDoc, @required this.index});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  String selectedValue, correctOption;
  int totalScore = 0;
  List<String> options = [];

  // List<String> shuffleQuestions(dynamic reqDoc) {
  //   List<String> options = [];
  //   QuestionModel questionModel = QuestionModel();
  //   questionModel.question = reqDoc.get("Ques");
  //   options = [
  //     reqDoc.get("01"),
  //     reqDoc.get("02"),
  //     reqDoc.get("03"),
  //     reqDoc.get("04"),
  //   ];
  //   return options;
  // }

  @override
  void initState() {
    // TODO: implement initState
    // QuestionModel questionModel = QuestionModel();
    // questionModel.question = widget.reqDoc.get("Ques");
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
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
                            selectedValue = value;
                          });
                          print("Option Selected: ${options[index]}");
                          if (options[index] == widget.reqDoc.get("01")) {
                            print("Correct answer!");

                            setState(() {
                              totalScore++;
                            });
                          } else {
                            print("Wrong answer");
                            print("Total Score is $totalScore");
                          }
                        }),
                    Text(options[index])
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class TimeLeft {
  String timeLeft(DateTime start, DateTime end) {
    String retVal;

    Duration _timeUntilDue = end.difference(start);

    int _minUntil = _timeUntilDue.inMinutes;
    int _secUntil = _timeUntilDue.inSeconds - (_minUntil * 60);

    retVal = _minUntil.toString() + " mins" + _secUntil.toString() + "sec";

    return retVal;
  }
}
