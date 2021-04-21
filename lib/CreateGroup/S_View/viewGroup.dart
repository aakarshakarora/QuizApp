import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as test;

import 'package:quiz_app/Theme/components/background.dart';


class ViewGroups extends StatefulWidget {
  @override
  _ViewGroupsState createState() => _ViewGroupsState();
}

class _ViewGroupsState extends State<ViewGroups> {
  final currentUser = FirebaseAuth.instance.currentUser.uid;
  String accessCode;

  ColorTween color = ColorTween(begin: Colors.orange[300], end: Colors.orange[700]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Group"),backgroundColor: Colors.orange,),
      body: Background(
        child: Container(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Student')
                  .doc(currentUser)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic> data = snapshot.data.data();
                final reqDoc = data['GroupAdded'];
                int docLen = data['GroupAdded'].length;
                print(docLen);
                return
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: new ListView.builder(
                        itemCount: docLen,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Column(
                              children: [
                                Container(
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        color: color.lerp(index / (docLen)),
                                        elevation: 5,
                                        child: Center(
                                          child: Text(
                                            reqDoc[index].toString().substring(
                                                65, reqDoc[index]
                                                .toString()
                                                .length - 1), style: TextStyle(
                                              color: Colors.white),),
                                        )),
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height*0.1,),
                              ],
                            ),
                          );
                        }),
                  );
              }),
        ),
      ),
    );
  }
}

// static List<Color> _alreadyUsedColors = [];
//
// Color _randomColor() {
//   Color newColor = Color((test.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
//   while (_alreadyUsedColors.contains(newColor))
//     newColor = Color((test.Random().nextDouble() * 0xFFFFFF).toInt())
//         .withOpacity(1.0);
//   _alreadyUsedColors.add(newColor);
//   return newColor;
// }
// ColorTween color = ColorTween(begin: Colors.deepPurple, end: Colors.purple);

//Colors.primaries[test.Random().nextInt(Colors.primaries.length)],
//_randomColor(),
//color.lerp(index/(5-1)),