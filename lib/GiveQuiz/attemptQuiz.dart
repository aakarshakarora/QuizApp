import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/CreateQuiz/addQuestion.dart';
import 'package:quiz_app/Utilities/buttons.dart';

import '../main.dart';
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

class _AttemptQuizState extends State<AttemptQuiz>{
  PageController pageController = PageController(initialPage: 0);
  int currentQuestion = 0;
  @override
  Widget build(BuildContext context) {
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
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: (BorderRadius.circular(20)),
                ),
              ),
              Container(width: MediaQuery.of(context).size.width*(2/widget.questionCount),
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: (BorderRadius.circular(20)),
                ),
              ),

            ],
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
                              totalQuestions: reqDocs.length,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                index == 0?Container():
                                roundedButton(
                                  color: Colors.blue,
                                    context: context,
                                    text: "Prev",
                                    onPressed: () {
                                      //currentQuestion--;
                                      print("Prev Button is pressed!");
                                      print(index);
                                      print(widget.questionCount);
                                      pageController.animateToPage(index-1, duration: Duration(milliseconds: 200), curve: Curves.easeInQuad);
                                      //Provider.of<Data>(context,listen: false).changeIndex(currentQuestion);
                                  }),
                                index != widget.questionCount-1
                                    ? roundedButton(
                                  color: Colors.blue,
                                        context: context,
                                        text: "Next",
                                        onPressed: () {
                                          //currentQuestion++;
                                          print("Next Button is pressed!");
                                          //print(currentQuestion);
                                          print(widget.questionCount);
                                          pageController.animateToPage(index+1, duration: Duration(milliseconds: 200), curve: Curves.easeInQuad);
                                          //Provider.of<Data>(context,listen: false).changeIndex(currentQuestion);
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
  final dynamic reqDoc, index,totalQuestions;
  QuestionTile(
      {@required this.reqDoc,
      @required this.index,
      @required this.totalQuestions});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> with AutomaticKeepAliveClientMixin{
  String selectedValue, correctOption;
  List<String> options = [];

  @override
  bool get wantKeepAlive => true;

  void calculateScore(){

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
    options.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            selectedValue = value;
                          });
                          print("Option Selected: ${options[index]}");

                          if (selectedValue == widget.reqDoc.get("01")) {
                            print("Correct answer!");
                          } else {
                            print("Wrong answer");
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
