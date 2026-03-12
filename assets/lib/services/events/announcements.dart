import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_connect/entities/widgets/models/announcements_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _announcements => _firestore.collection('announcements');

  Stream<List<Announcement>> getAnnouncements() {
    return _announcements
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Announcement.fromFirestore(doc))
            .toList());
  }

  // Get announcements by priority
  Stream<List<Announcement>> getAnnouncementsByPriority(AnnouncementPriority priority) {
    return _announcements
        .where('priority', isEqualTo: priority.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Announcement.fromFirestore(doc))
            .toList());
  }

  // Create new announcement (officers/advisors only)
  Future<void> createAnnouncement({
    required String title,
    required String content,
    required AnnouncementPriority priority,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    // Check if user is officer or advisor
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final role = userData['role'] ?? 'member';
    
    if (role != 'officer' && role != 'advisor') {
      throw Exception('Only officers and advisors can create announcements');
    }

    await _announcements.add({
      'title': title,
      'content': content,
      'authorId': user.uid,
      'authorName': userData['fullName'] ?? 'Unknown',
      'authorPhotoUrl': userData['profilePhotoUrl'],
      'priority': priority.name,
      'createdAt': FieldValue.serverTimestamp(),
      'readBy': [],
    });
  }

  // Mark announcement as read by current user
  Future<void> markAsRead(String announcementId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _announcements.doc(announcementId).update({
      'readBy': FieldValue.arrayUnion([userId]),
    });
  }

  // Update announcement (officers/advisors only)
  Future<void> updateAnnouncement({
    required String announcementId,
    String? title,
    String? content,
    AnnouncementPriority? priority,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    // Verify permissions
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final role = userData['role'] ?? 'member';
    
    if (role != 'officer' && role != 'advisor') {
      throw Exception('Only officers and advisors can update announcements');
    }

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (title != null) updates['title'] = title;
    if (content != null) updates['content'] = content;
    if (priority != null) updates['priority'] = priority.name;

    await _announcements.doc(announcementId).update(updates);
  }

  // Delete announcement (officers/advisors only)
  Future<void> deleteAnnouncement(String announcementId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    // Verify permissions
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final role = userData['role'] ?? 'member';
    
    if (role != 'officer' && role != 'advisor') {
      throw Exception('Only officers and advisors can delete announcements');
    }

    await _announcements.doc(announcementId).delete();
  }

  // Get unread count for current user
  Future<int> getUnreadCount() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return 0;

    final snapshot = await _announcements
        .where('readBy', arrayContains: userId)
        .get();
    
    final allSnapshot = await _announcements.get();
    return allSnapshot.docs.length - snapshot.docs.length;
  }
}