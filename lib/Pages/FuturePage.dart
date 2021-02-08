import 'package:flutter/material.dart';


class FuturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Upcoming Page",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Center(
          child: Text(
            "This Page Will Come in Next Update",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          )),
    );
  }
}
