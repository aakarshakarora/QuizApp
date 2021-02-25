import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/GiveQuiz/attemptQuiz.dart';


class EnterCode extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final TextEditingController _accessCodeController = TextEditingController();

  _buildAccessCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            labelText: 'Enter Access Code:',
            labelStyle: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins',
            )),
        keyboardType: TextInputType.text,
        controller: _accessCodeController,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Give Quiz"),
        ),
        body: Column(
          children: [
            _buildAccessCodeField(),
            FlatButton(
              onPressed: () async {
                setState(() {
                  print("The access code is: " + _accessCodeController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizCodeDesc(_accessCodeController.text)),
                  );
                });
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
  static String code, facultyName;
  bool open = true;
  int score=0,tabSwitch=0;
  final userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    print(uid);
    return uid.toString();
  }

  String getUserEmail() {
    final User user = _auth.currentUser;
    final uEmail = user.email;
    print(uEmail);
    return uEmail.toString();
  }

  String uId, uName, uEmailId,uRegNo;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      code = widget.accessCode;
      super.initState();
      uId = getUserID();
      uEmailId = getUserEmail();
      FirebaseFirestore.instance.collection('Student').doc(uId).get().then((value) {
        uName=value.data()['S_Name'];
        uRegNo=value.data()['S_RegNo'];
      });
    });
  }

  _getFacultyName(DocumentReference documentReference) async {
    await documentReference.get().then((value) {
      setState(() {
        facultyName = value.data()['F_Name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Description"),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
            future:
            FirebaseFirestore.instance.collection('Quiz').doc(code).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData && (facultyName == null)) {
                return Center(child: CircularProgressIndicator());
              }
              else {
                Map<String, dynamic> data = snapshot.data.data();

                DocumentReference documentReference = data['Creator'];
                _getFacultyName(documentReference);


                return Column(
                  children: [
                    Text('Subject Name:' + data['SubjectName']),
                    Text('Description: ' + data['Description']),
                    Text('Question Count: ' + data['QuestionCount'].toString()),
                    Text('Max  Score: ' + data['MaxScore'].toString()),
                    Text('Question Count:' + data['QuestionCount'].toString()),
                    Text('Start Time: ' + data['startDate'].toString()),
                    Text('End Time: ' + data['endDate'].toString()),
                    Text("Creator Name:$facultyName "),
                    FlatButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('Quiz')
                              .doc(code)
                              .collection(code + 'Result')
                              .doc(uId)
                              .set({
                            'S_Name': uName,
                            'S_UID': uId,
                            'S_RegNo': uRegNo,
                            'S_EmailID': uEmailId,
                            'Login': open,
                            'Score': score,
                            'tabSwitch': tabSwitch
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AttemptQuiz(
                                      subjectName: data['SubjectName'],
                                      accessCode: code,
                                    )),
                          );
                        },
                        child: Text("Give Quiz"))
                  ],
                );
              }
            }),
      ),
    );
  }
}
