import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/Pages/FuturePage.dart';
import 'package:quiz_app/Utilities/buttons.dart';

class AttemptQuiz extends StatefulWidget {
  final String subjectName, accessCode;
  final int questionCount;

  AttemptQuiz(
      {@required this.accessCode,
      @required this.subjectName,
      @required this.questionCount});

  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> with WidgetsBindingObserver {
  int pause = 0, resume = 0, inactive = 0, dead = 0;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  Timestamp sTime, eTime;
  DateTime res1, res2;

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

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  PageController pageController = PageController(initialPage: 0);
  int currentQuestion = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print(currentQuestion);
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
            endTime: res2.millisecondsSinceEpoch + 1000 * 30,
            widgetBuilder: (_, CurrentRemainingTime time) {
              if (time == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FuturePage()),
                );
              }
              return Text(
                  ' hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
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
                    onPageChanged: (index) {
                      currentQuestion = index;
                      //print(currentQuestion);
                    },
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
                              totalQuestions: reqDocs.length,
                            ),
                            // SizedBox(
                            //   height: 100,
                            // ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentQuestion == 1
                  ? Container()
                  : roundedButton(
                      color: Colors.blue,
                      context: context,
                      text: "Prev",
                      onPressed: () {
                        print("Prev Button is pressed!");
                        if (currentQuestion > 0) {
                          pageController.animateToPage(--currentQuestion,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInQuad);
                        }

                        //Provider.of<Data>(context,listen: false).changeIndex(currentQuestion);
                      }),
              currentQuestion != widget.questionCount - 1
                  ? roundedButton(
                      color: Colors.blue,
                      context: context,
                      text: "Next",
                      onPressed: () {
                        print("Next Button is pressed!");
                        if (currentQuestion < widget.questionCount - 1) {
                          pageController.animateToPage(++currentQuestion,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInQuad);
                        }
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
                print(currentQuestion);
                print(widget.questionCount);
              })
        ],
      ),
    );
  }
}

class QuestionTile extends StatefulWidget {
  final dynamic reqDoc, index, totalQuestions;

  QuestionTile({
    @required this.reqDoc,
    @required this.index,
    @required this.totalQuestions,
  });

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    secureScreen();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  String selectedValue, correctOption;
  List<String> options = [];

  @override
  bool get wantKeepAlive => true;

  void calculateScore() {}

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

  bool marked = true;

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
                    GestureDetector(
                      child: Radio(
                          value: options[index],
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                              marked = true;
                            });

                            print("Option Selected: ${options[index]}");

                            if (selectedValue == widget.reqDoc.get("01")) {
                              //GestureDetector
                              print("Correct answer!");
                            } else {
                              print("Wrong answer");
                            }
                          }),
                    ),
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
