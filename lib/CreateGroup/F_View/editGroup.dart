import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/CreateGroup/F_View/addStudent.dart';
import 'package:quiz_app/CreateGroup/F_View/deleteStudent.dart';

import '../../Theme/components/background.dart';

class EditGroup extends StatefulWidget {
  final String groupName;
  EditGroup(this.groupName);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  String currentUser;


  final titles = [ 'Remove Students','Add Students'];


  final titleIcon = [
    Icon(Icons.delete,color: Colors.white,),
    Icon(Icons.add,color: Colors.white,)
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.groupName}"),
      ),

      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: titles.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      child: Card(
                        elevation: 5,
                        color: cardColors[index],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        //color: Theme.of(context).primaryColor,
                        child: Container(
                          height: 100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                titleIcon[index],
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                    color: Colors.white
                                  ),
                                ),
                              ],

                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        DocumentReference docRef =
                        FirebaseFirestore.instance.collection('Faculty').doc(currentUser).collection('QuizGroup').doc(widget.groupName);
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeleteStudent(widget.groupName, docRef)),
                          );
                        }
                        if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddStudent(widget.groupName, docRef)),
                          );
                        }

                      },
                    );
                  },
                ),
              ],
          ),
        ),
      ),
    );
  }
}
