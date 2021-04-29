import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:quiz_app/PreviewQuiz/previewQuizDesc.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/Theme/components/rounded_button.dart';

class ViewQuizDesc extends StatefulWidget {
  @override
  _ViewQuizDescState createState() => _ViewQuizDescState();
}

class _ViewQuizDescState extends State<ViewQuizDesc> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  var firestoreDB = FirebaseFirestore.instance
      .collection('Quiz')
      //.where("startDate",isLessThan: new DateTime.now())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text("Preview Quiz"),
          centerTitle: true,
        ),
        body: Background(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: firestoreDB,
                    builder: (ctx, opSnapshot) {
                      if (opSnapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      final reqDocs = opSnapshot.data.documents;
                      print('length ${reqDocs.length}');
                      return ListView.builder(
                        itemCount: reqDocs.length,
                        itemBuilder: (ctx, index) {
                          if (reqDocs[index]
                              .get('Creator')
                              .toString()
                              .contains(userId))
                            return ViewDetails(reqDocs[index],reqDocs.length,index);
                          return Container(
                            height: 0,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ViewDetails extends StatefulWidget {
  final dynamic reqDoc,docLength,index;

  ViewDetails(this.reqDoc,this.docLength,this.index);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {

  ColorTween color = ColorTween(begin: Colors.pink[100], end: Colors.pink[400]);

  @override
  Widget build(BuildContext context) {
    String message;
    final accessCode = widget.reqDoc.get("AccessCode");
    final questionCount = widget.reqDoc.get("QuestionCount");

    final subjectName = widget.reqDoc.get("SubjectName");
    final description = widget.reqDoc.get("Description");
    final sDate = (widget.reqDoc.get("startDate") as Timestamp).toDate();
    final eDate = (widget.reqDoc.get("endDate") as Timestamp).toDate();

    final startDate =
        (widget.reqDoc.get("startDate") as Timestamp).toDate().toString();
    final endDate =
        (widget.reqDoc.get("endDate") as Timestamp).toDate().toString();

    final maxScore = widget.reqDoc.get("MaxScore");

    message =
        " Subject Name: $subjectName \n Question Count: $questionCount \n Max Score: $maxScore  \n\n Start Time: $startDate \n End Date: $endDate \n\n Access Code: $accessCode";

    return Container(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          elevation: 5,
          color: color.lerp(widget.index / (widget.docLength)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Question Count:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$questionCount',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Access Code:',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$accessCode',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Subject Name:',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$subjectName',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'MaxScore:',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$maxScore',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Start Date:',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$startDate',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    ),
                  ],
                ),

                RoundedButton(text: 'Share Quiz',press: () async {
                  var response;
                  await FlutterShareMe().shareToSystem(msg: message);
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
                color: Colors.blue,
                textColor: Colors.black,),
                RoundedButton(text: "Edit Quiz",press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewQuizDesc(
                            description: description,
                            eDate: eDate,
                            sDate: sDate,
                            accessCode: accessCode,
                            subjectName: subjectName,
                            questionCount: questionCount,
                            maximumScore: maxScore)),
                  );
                },
                  color: Colors.grey[800],
                  textColor: Colors.white,),
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => PreviewQuizDesc(
                //                 description: description,
                //                 eDate: eDate,
                //                 sDate: sDate,
                //                 accessCode: accessCode,
                //                 subjectName: subjectName,
                //                 questionCount: questionCount,
                //                 maximumScore: maxScore)),
                //       );
                //     },
                //     child: Text("Edit Quiz"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
