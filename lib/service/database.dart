import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future addCourse(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Course")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAllCourse() async {
    return await FirebaseFirestore.instance.collection("Course").snapshots();
  }

  Future updateCount(String id, String number) async {
    return await FirebaseFirestore.instance
        .collection("Course")
        .doc(id)
        .update({"Count": number});
  }

  Future addVideo(Map<String, dynamic> userVideoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Course")
        .doc(id)
        .collection("Videos")
        .add(userVideoMap);
  }

  Future<Stream<QuerySnapshot>> getAllVideos(String id) async {
    return await FirebaseFirestore.instance
        .collection("Course")
        .doc(id)
        .collection("Videos")
        .snapshots();
  }
}
