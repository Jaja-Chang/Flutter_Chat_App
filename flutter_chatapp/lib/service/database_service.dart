import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // reference for the collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // updating the user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // getting user groups (chats)
  getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group (chat)
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });

    // update members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id
    });

    // add the group to the user's document and return
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // get the chats
  getChats(String groupId) async {
    // set descending to "true" so it can be used with "CustomerCrollView" on
    // the chat page to scroll to the latest message
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  // TODO: search by entering first few characters
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // check if the user has already joined the group
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocRef.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    }
    return false;
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String groupName, String userName) async {
    // doc reference
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocRef.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //if user has our groups then remove them else join
    // print("Member: ${uid}_$userName");
    if (groups.contains("${groupId}_$groupName")) {
      await userDocRef.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocRef.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocRef.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocRef.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
