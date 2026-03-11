import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_connect/entities/widgets/models/post_model.dart';
import 'package:fbla_connect/services/user_storage/FBLA_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _posts => _firestore.collection('posts');

  Future<void> createPost(String content, {String? eventId, String? achievementId}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = FBLAUser.fromMap(user.uid, userDoc.data() as Map<String, dynamic>);

    await _posts.add({
      'userId': user.uid,
      'userName': userData.fullName,
      'userPhotoUrl': userData.profilePhotoUrl,
      'content': content,
      'likes': [],
      'commentCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'eventId': eventId,
      'achievementId': achievementId,
    });
  }

  Stream<List<CommunityPost>> getPosts() {
    return _posts.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CommunityPost.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> likePost(String postId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final postRef = _posts.doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final postRef = _posts.doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }
}