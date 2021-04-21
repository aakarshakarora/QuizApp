import 'package:flutter/material.dart';
import 'package:quiz_app/Common/studentBar.dart';
import 'package:quiz_app/Theme/components/background.dart';
import 'package:quiz_app/Theme/theme.dart';

class PostQuiz extends StatefulWidget {
  final int score, inactive, totalScore;

  PostQuiz(
      {@required this.score,
      @required this.inactive,
      @required this.totalScore});

  @override
  _PostQuizState createState() => _PostQuizState();
}

class _PostQuizState extends State<PostQuiz> {
  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.deepPurple,
        //   title: Text(
        //     "Upcoming Page",
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold, fontSize: 20),
        //   ),
        // ),
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20,),
              Text(
                "Thank You for Giving Quiz !! \n Your Score: " +
                    widget.score.toString() +
                    "/${widget.totalScore}\n Tab Switched: " +
                    widget.inactive.toString(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                "assets/images/quiz.jpg",
                //width: size.width * 0.35,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentBar()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Go to Home"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
