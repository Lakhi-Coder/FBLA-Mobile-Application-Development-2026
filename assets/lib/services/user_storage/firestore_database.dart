import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_connect/services/user_storage/FBLA_user.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> addUser(String userId, String email, String chapterNumber, String gradeLevel, String fullname, String role) {
  final user = FBLAUser(
    uid: userId,
    email: email,
    fullName: fullname,
    role: role,
    chapterNumber: chapterNumber,
    gradeLevel: gradeLevel,
    createdAt: DateTime.now(),
  ).toMap();

  return db.collection("users").doc(userId).set(user)
      .then((value) => print("User Added")) 
      .catchError((error) => print("Failed to add user: $error")); 
}
