import 'package:cloud_firestore/cloud_firestore.dart';

class FBLAUser {
  final String uid;
  final String email;
  final String fullName;
  final String role; 
  final String chapterNumber;
  final String? chapterName;
  final String gradeLevel;
  final DateTime createdAt;
  final bool isVerified;
  final List<String> achievements; 
  final int serviceHours;
  final List<String> eventsAttended;
  final List<String> favoriteResources;
  final Map<String, dynamic> notificationPreferences;
  final String? profilePhotoUrl;
  final List<String> deviceTokens; 

  FBLAUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.chapterNumber,
    this.chapterName,
    required this.gradeLevel,
    required this.createdAt,
    this.isVerified = false,
    this.achievements = const [],
    this.serviceHours = 0,
    this.eventsAttended = const [],
    this.favoriteResources = const [],
    this.notificationPreferences = const {},
    this.profilePhotoUrl,
    this.deviceTokens = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,
      'chapterNumber': chapterNumber,
      'chapterName': chapterName,
      'gradeLevel': gradeLevel,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'achievements': achievements,
      'serviceHours': serviceHours,
      'eventsAttended': eventsAttended,
      'favoriteResources': favoriteResources,
      'notificationPreferences': notificationPreferences,
      'profilePhotoUrl': profilePhotoUrl,
      'deviceTokens': deviceTokens,
    };
  }

  factory FBLAUser.fromMap(String uid, Map<String, dynamic> map) {
    return FBLAUser(
      uid: uid,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? 'member',
      chapterNumber: map['chapterNumber'] ?? '',
      chapterName: map['chapterName'],
      gradeLevel: map['gradeLevel'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: map['isVerified'] ?? false,
      achievements: List<String>.from(map['achievements'] ?? []),
      serviceHours: map['serviceHours'] ?? 0,
      eventsAttended: List<String>.from(map['eventsAttended'] ?? []),
      favoriteResources: List<String>.from(map['favoriteResources'] ?? []),
      notificationPreferences: map['notificationPreferences'] ?? {},
      profilePhotoUrl: map['profilePhotoUrl'],
      deviceTokens: List<String>.from(map['deviceTokens'] ?? []),
    );
  }
}