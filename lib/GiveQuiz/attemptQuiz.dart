import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Utilities/buttons.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../main.dart';
import 'globals.dart' as global;

class AttemptQuiz extends StatefulWidget {
  final String subjectName, accessCode;
  final int questionCount, maximumScore;

  AttemptQuiz(
      {@required this.accessCode,
      @required this.subjectName,
      @required this.questionCount,
      @required this.maximumScore});

  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> {
  PageController pageController = PageController(initialPage: 0);

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearPercentIndicator(
              addAutomaticKeepAlive: true,
              animation: true,
              // animateFromLastPercent: false,
              // animationDuration: 500,
              lineHeight: 14.0,
              percent: Provider.of<Data>(context).questionCount /
                  widget.questionCount,
              backgroundColor: Colors.white,
              progressColor: Colors.orange,
            ),
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
                              correctAnswerMarks: (widget.maximumScore)/(reqDocs.length),
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
                                  print(index);
                                  print(widget.questionCount);

                                })
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
                              global.correct[widget.index]=1;
                            } else {
                              print("Wrong answer");
                            }

                          print("Questions attempted: ${global.attempted}");
                          print(global.attempted.reduce((a, b) => a + b));
                          print("Questions correct: ${global.correct}");
                          print("Total Score:${(global.correct.reduce((a, b) => a + b))*widget.correctAnswerMarks}");
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
