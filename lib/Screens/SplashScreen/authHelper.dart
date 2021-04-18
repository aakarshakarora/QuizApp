import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    Map<String, dynamic> userData = {
      "UserID": user.uid,
      "lastLogin": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      //"build_number": buildNumber,
    };
    final userRef = _db.collection("User").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "lastLogin": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
  }
}
