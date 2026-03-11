// models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final List<String> likes;        // array of user IDs who liked
  final int commentCount;           // denormalized count
  final DateTime createdAt;
  final String? eventId;            // optional: linked event
  final String? achievementId;      // optional: linked achievement

  CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    required this.likes,
    required this.commentCount,
    required this.createdAt,
    this.eventId,
    this.achievementId,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'userPhotoUrl': userPhotoUrl,
    'content': content,
    'likes': likes,
    'commentCount': commentCount,
    'createdAt': Timestamp.fromDate(createdAt),
    'eventId': eventId,
    'achievementId': achievementId,
  };

  factory CommunityPost.fromMap(String id, Map<String, dynamic> map) {
    return CommunityPost(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      content: map['content'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      commentCount: map['commentCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventId: map['eventId'],
      achievementId: map['achievementId'],
    );
  }
}