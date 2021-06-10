import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Model/resultModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChartDisplay extends StatefulWidget {
  final String accessCode;

  PieChartDisplay(this.accessCode);

  @override
  _PieChartDisplayState createState() => _PieChartDisplayState();
}

class _PieChartDisplayState extends State<PieChartDisplay> {
  final String currentUser = FirebaseAuth.instance.currentUser.uid;
  int score, inactiveState;


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .collection(widget.accessCode + 'Result')
        .doc(currentUser)
        .get()
        .then((value) {
      setState(() {
        score = value.data()['Score'];
        inactiveState = value.data()['tabSwitch'];
      });
      score = value.data()['Score'];
      inactiveState = value.data()['tabSwitch'];
      print("Score: $score");
      print("Inactive: $inactiveState");
    });
  }

  List<charts.Series<ResultModel, String>> _seriesPieData;
  List<ResultModel> myData;
  List<int> studentScore=[];


  _generateData(myData) {
    _seriesPieData = List<charts.Series<ResultModel, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (ResultModel task, _) => task.score.toString(),
        measureFn: (ResultModel task, _) => task.maxScore,
        id: 'tasks',
        data: myData,
        labelAccessorFn: (ResultModel row, _) => "${row.score}",

      ),
    );

  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Quiz')
          .doc(widget.accessCode)
          .collection(widget.accessCode + 'Result')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {

          // final reqDoc = snapshot.data.docs;

          List<ResultModel> task = snapshot.data.docs
              .map((documentSnapshot) =>
              ResultModel.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, task,snapshot.data.docs.length,);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ResultModel> Resultdata ,int totalSubmission) {
    myData = Resultdata;
    _generateData(myData);

    //int sum =studentScore.reduce((a, b) => a+b);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Pie Chart',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text("Your Score is: "+score.toString()),
              Text("Inactive State Count: " +inactiveState.toString()),
             // Text("Average: "+totalSubmission.toString()),
              // Text("Sum is: "+sum.toString()),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                            right: 4.0, bottom: 4.0, top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.auto)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart'),
      ),
      body: _buildBody(context),
    );
  }
}
