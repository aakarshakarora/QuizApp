import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/Charts/pieChart.dart';
import 'package:quiz_app/Theme/components/background.dart';

import 'dart:convert';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as genExcel;

class QuizCreatedRecord extends StatefulWidget {
  @override
  _QuizCreatedRecordState createState() => _QuizCreatedRecordState();
}

class _QuizCreatedRecordState extends State<QuizCreatedRecord> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser, accessCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ColorTween color =
      ColorTween(begin: Colors.orange[100], end: Colors.orange[400]);

//Get Current User
  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final uemail = user.email;
    // print(uid);
    // print(uemail);
    return uid.toString();
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Quiz Created"),
        centerTitle: true,
      ),
      body: Background(
        child: SafeArea(
          child: Container(
            child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Faculty')
                    .doc(currentUser)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic> data = snapshot.data.data();
                  final reqDoc = data['QuizCreated'];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: new ListView.builder(
                        itemCount: data['QuizCreated'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Column(
                              children: [

                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        elevation: 5,
                                        color: color.lerp(
                                            index / (data['QuizCreated'].length)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),

                                          child: TextButton(
                                            child: Text(reqDoc[index].toString(),style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                            ),),


                                            onPressed: () {
                                              setState(() {
                                                accessCode = reqDoc[index]
                                                    .toString()
                                                    .substring(0, 5);
                                              });
                                              print(accessCode);

                                              generateExcel(
                                                  accessCode + 'Result');
                                            },
                                          ),
                                        ))),
                              ],
                            ),
                          );
                        }),
                  );
                }),
          ),
        ),
      ),
    );
  }

  int count = 2;

  Future<void> generateExcel(String accessCode) async {
    print("Function Called");
    //Create a Excel document.

    //Creating a workbook.
    final genExcel.Workbook workbook = genExcel.Workbook();
    //Accessing via index
    final genExcel.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.

    sheet.getRangeByName('A1').setText('Name');
    sheet.getRangeByName('B1').setText('ID');
    sheet.getRangeByName('C1').setText('Email ID');
    sheet.getRangeByName('D1').setText('Score');
    sheet.getRangeByName('E1').setText('Tab Switch');
    sheet.getRangeByName('F1').setText('Logged In');
    sheet.getRangeByName('G1').setText('User ID');
    sheet.getRangeByName('H1').setText('Max Score');
    String subjectName;
    String code;
    code = accessCode.substring(0, 5);

    final cloud = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(code)
        .collection(accessCode)
        .get();

    print("Code is: $accessCode");

    for (var document in cloud.docs) {
      sheet
          .getRangeByName('A' + count.toString())
          .setText(document.data()['S_Name'].toString());
      sheet
          .getRangeByName('B' + count.toString())
          .setText(document.data()['S_RegNo'].toString());
      sheet
          .getRangeByName('C' + count.toString())
          .setText(document.data()['S_EmailID'].toString());
      sheet
          .getRangeByName('D' + count.toString())
          .setText(document.data()['Score'].toString());
      sheet
          .getRangeByName('E' + count.toString())
          .setText(document.data()['tabSwitch'].toString());
      sheet
          .getRangeByName('F' + count.toString())
          .setText(document.data()['attempted'].toString());
      sheet
          .getRangeByName('G' + count.toString())
          .setText(document.data()['S_UID'].toString());
      sheet
          .getRangeByName('H' + count.toString())
          .setText(document.data()['maxScore'].toString());

      count++;
    }

    await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(code)
        .get()
        .then((value) {
      subjectName = value.data()['SubjectName'];
    });

    sheet.getRangeByName('A1:E1').cellStyle.backColor = '#FFFF00';
    sheet.getRangeByName('A1:E1').cellStyle.bold = true;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Get the storage folder location using path_provider package.
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$subjectName $code.xlsx');
    await file.writeAsBytes(bytes);

    //Launch the file (used open_file package)

    await open_file.OpenFile.open('$path/$subjectName $code.xlsx');

    print("File Saved at:" + path);
    print("Code is: $accessCode");
    print("Result is: $code");
  }
}
