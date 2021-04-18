import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/GiveQuiz/attemptQuiz.dart';
import 'package:quiz_app/Theme/theme.dart';

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
        decoration: kTextFieldDecoration.copyWith(
          labelText: 'Enter Quiz Code',
        ),
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Enter Access Code to Give Quiz"),
              SizedBox(
                height: 50,
              ),
              _buildAccessCodeField(),
              SizedBox(
                height: 50,
              ),
              MaterialButton(
                color: kPrimaryColor,
                onPressed: () async {
                  setState(() {
                    //print("The access code is: " + _accessCodeController.text);
                    if (_accessCodeController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizCodeDesc(
                                _accessCodeController.text.trim())),
                      );
                    }
                  });
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/enterCode.jpg",
                height: 200,
              )
            ],
          ),
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
  static int endTime, startTime, currentTime;
  Timestamp sTime, eTime, cTime;
  DateTime res1, res2;
  bool attempted = false;
  static bool groupCheck;
  List studentGroup;

  int score = 0, tabSwitch = 0;
  final userId = FirebaseAuth.instance.currentUser.uid;
  final uEmailId = FirebaseAuth.instance.currentUser.email;

  String uName, uRegNo;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      code = widget.accessCode;
      super.initState();

      FirebaseFirestore.instance
          .collection('Student')
          .doc(userId)
          .get()
          .then((value) {
        uName = value.data()['S_Name'];
        uRegNo = value.data()['S_RegNo'];
      });

      FirebaseFirestore.instance
          .collection('Quiz')
          .doc(code)
          .collection(code + 'Result')
          .doc(userId)
          .get()
          .then((value) async {
        attempted = await value.data()['attempted'];
        print("Login Status :$attempted");
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

  _groupCheck(DocumentReference documentReference) async {
    await documentReference.get().then((value) {
      studentGroup = value.data()['AllottedStudent'];
    });

    if (studentGroup.contains(userId)) {
      print("Yes, It contains UID");
      setState(() {
        groupCheck = true;
      });
    } else {
      print("No,It doesn't UID");
      setState(() {
        groupCheck = false;
      });
      print(groupCheck);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Description"),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Container(
              child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Quiz')
                      .doc(code)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData && (facultyName == null)) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData == false) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      Map<String, dynamic> data = snapshot.data.data();
                      DocumentReference documentReference = data['Creator'];
                      DocumentReference groupRef = data['QuizGroup'];
                      _getFacultyName(documentReference);
                      _groupCheck(groupRef);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/attemptQuiz.png",

                          ),
                          SizedBox(height: 10,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Access Code: ',
                                style: darkSmallTextBold,
                              ),
                              Text(
                                widget.accessCode,
                                style: darkSmallText,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                'Subject Name: ',
                                style: darkSmallTextBold,
                              ),
                              Text(
                                data['SubjectName'],
                                style: darkSmallText,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Description: ',
                                style: darkSmallTextBold,
                              ),
                              Text(data['Description'],
                                style: darkSmallText,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Question Count: ',
                                style: darkSmallTextBold,
                              ),
                              Text(data['QuestionCount'].toString(),
                                style: darkSmallText,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Max  Score: ',
                                style: darkSmallTextBold,
                              ),
                              Text(data['MaxScore'].toString(),
                                style: darkSmallText,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Start Time: ',
                                style: darkSmallTextBold,
                              ),
                              Text((data['startDate'] as Timestamp)
                                  .toDate()
                                  .toString(),
                                style: darkSmallText,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'End Time: ',
                                style: darkSmallTextBold,
                              ),
                              Text((data['endDate'] as Timestamp)
                                  .toDate()
                                  .toString(),
                                style: darkSmallText,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Creator Name: ",
                                style: darkSmallTextBold,
                              ),
                              Text(facultyName,
                                style: darkSmallText,)
                            ],
                          ),
                          groupCheck == true
                              ? Row(
                                  children: [
                                    Text(
                                      "You are allowed to give Quiz ",
                                      style: darkSmallTextBold,
                                    ),
                                    Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      "You are not allowed to give Quiz ",
                                      style: darkSmallTextBold,
                                    ),
                                    Icon(Icons.not_interested, color: Colors.red)
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            color: kPrimaryColor,
                            onPressed: () async {
                              sTime = (data['startDate']);
                              startTime =
                                  sTime.millisecondsSinceEpoch + 1000 * 30;

                              eTime = (data['endDate']);
                              endTime = eTime.millisecondsSinceEpoch + 1000 * 30;

                              currentTime =
                                  DateTime.now().millisecondsSinceEpoch +
                                      1000 * 30;

                              print("Start Date: $startTime");
                              print("End Date: $endTime");
                              print("Current Date: $currentTime");
                              print("Attempted Check: " + attempted.toString());
                              print("Group Check:" + groupCheck.toString());

                              if (attempted == true && groupCheck == false) {
                                //print("This is being called");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentDashboard()),
                                );
                              } else if (attempted == false &&
                                  groupCheck == true) {
                                if (startTime <= currentTime &&
                                    endTime >= currentTime) {
                                  FirebaseFirestore.instance
                                      .collection('Quiz')
                                      .doc(code)
                                      .collection(code + 'Result')
                                      .doc(userId)
                                      .set({
                                    'S_Name': uName,
                                    'S_UID': userId,
                                    'S_RegNo': uRegNo,
                                    'S_EmailID': uEmailId,
                                    'attempted': attempted,
                                    'Score': score,
                                    'tabSwitch': tabSwitch,
                                    'maxScore': data['MaxScore']
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AttemptQuiz(
                                              marksPerQuestion:
                                                  data['MarksPerQuestion'],
                                              subjectName: data['SubjectName'],
                                              accessCode: code,
                                              questionCount:
                                                  data['QuestionCount'],
                                              maximumScore: data['MaxScore'],
                                              timeCount: endTime,
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentDashboard()),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Give Quiz",
                              style: TextStyle(color: white),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
