import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Pages/FuturePage.dart';

class EnterCode extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final accessCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Give Quiz"),
        ),
        body: Column(
          children: [
            TextFormField(
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  labelText: 'Enter Access Code:',
                  labelStyle: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Poppins',
                  )),
              keyboardType: TextInputType.text,
              controller: accessCodeController,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizCodeDesc(accessCodeController.text)),
                );
              },
              child: Text("Submit"),
            ),
          ],
        ));
  }
}

class QuizCodeDesc extends StatefulWidget {
  final String accessCode;

  QuizCodeDesc(this.accessCode);

  @override
  _QuizCodeDescState createState() => _QuizCodeDescState();
}

class _QuizCodeDescState extends State<QuizCodeDesc> {


  static String facultyName;

  @override
  Widget build(BuildContext context) {
    var firebaseDB =
        FirebaseFirestore.instance.collection('Quiz').doc(widget.accessCode);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Description"),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: firebaseDB.get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data = snapshot.data.data();

              String parameter = data['Creator'].toString().substring(18, 54);

              FirebaseFirestore.instance.doc(parameter).get().then((value) {
                facultyName = value.data()['F_Name'];

                print(facultyName);
              });

              return Column(
                children: [
                  Text('Subject Name:' + data['SubjectName']),
                  Text('Description: ' + data['Description']),
                  Text('Question Count: ' + data['QuestionCount'].toString()),
                  Text('Max  Score: ' + data['MaxScore'].toString()),
                  Text('Question Count:' + data['QuestionCount'].toString()),
                  Text('Start Time: ' + data['startDate'].toString()),
                  Text('End Time: ' + data['endDate'].toString()),

                  Text("Creator Name: " + facultyName),



                  FlatButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Quiz')
                            .doc(widget.accessCode)
                            .collection('TA2Ri_Result').add({'null':null});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FuturePage()),
                        );
                      },
                      child: Text("Give Quiz"))
                ],
              );
            }),
      ),
    );
  }
}
