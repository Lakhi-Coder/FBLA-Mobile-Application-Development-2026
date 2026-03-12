import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

enum AnnouncementPriority {
  normal,
  important,
  urgent;

  static AnnouncementPriority fromString(String value) {
    switch (value) {
      case 'urgent':
        return AnnouncementPriority.urgent;
      case 'important':
        return AnnouncementPriority.important;
      default:
        return AnnouncementPriority.normal;
    }
  }

  String toJson() {
    switch (this) {
      case AnnouncementPriority.urgent:
        return 'urgent';
      case AnnouncementPriority.important:
        return 'important';
      case AnnouncementPriority.normal:
        return 'normal';
    }
  }

  Color get color {
    switch (this) {
      case AnnouncementPriority.urgent:
        return Colors.red;
      case AnnouncementPriority.important:
        return Colors.orange;
      case AnnouncementPriority.normal:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case AnnouncementPriority.urgent:
        return Icons.priority_high;
      case AnnouncementPriority.important:
        return Icons.warning;
      case AnnouncementPriority.normal:
        return Icons.info;
    }
  }
}

class Announcement {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final AnnouncementPriority priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> readBy; // user IDs who have seen it

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.readBy = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'priority': priority.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'readBy': readBy,
    };
  }

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Unknown',
      authorPhotoUrl: data['authorPhotoUrl'],
      priority: AnnouncementPriority.fromString(data['priority'] ?? 'normal'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }
}