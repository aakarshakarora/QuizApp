import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                      builder: (context) => QuizCodeDesc(accessCodeController.text)),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Description"),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Quiz')
                .doc(widget.accessCode)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data = snapshot.data.data();
              return Column(
                children: [
                  Text('Subject Name:' + data['SubjectName']),
                  Text('Description: ' + data['Description']),
                  Text('Question Count: ' + data['QuestionCount'].toString()),
                  Text('Max  Score: ' + data['MaxScore'].toString()),
                  Text('Question Count:' + data['QuestionCount'].toString()),
                  Text('Start Time: ' + data['startDate'].toString()),
                  Text('End Time: ' + data['endDate'].toString()),
                  Text("Creator Name: "),
                  //How to display Creator Name Through Reference

                  FlatButton(onPressed: null, child: Text("Give Quiz"))
                ],
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
print("hello");
    print(widget.accessCode);
    super.initState();
  }
}
