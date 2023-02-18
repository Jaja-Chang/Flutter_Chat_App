import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // reference for the collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference GroupCollection =
      FirebaseFirestore.instance.collection("groups");

  // updating the userdata
  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "group": [],
      "profilePic": "",
      "uid": uid,
    });
  }
}
