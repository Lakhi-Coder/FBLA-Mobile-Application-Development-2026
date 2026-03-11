import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class FBLAEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime? endDate;
  final String location;
  final String eventType;
  final DateTime registrationDeadline;
  final int maxParticipants;
  final List<String> registeredUsers;
  final String organizer;
  final bool isVirtual;
  final String? meetingLink;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;

  FBLAEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.endDate,
    required this.location,
    required this.eventType,
    required this.registrationDeadline,
    required this.maxParticipants,
    required this.registeredUsers,
    required this.organizer,
    required this.isVirtual,
    this.meetingLink,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  bool isUserRegistered(String userId) => registeredUsers.contains(userId);
  bool get hasSpotsAvailable => registeredUsers.length < maxParticipants;
  bool get isRegistrationOpen =>
      DateTime.now().isBefore(registrationDeadline) && hasSpotsAvailable;
  int get availableSpots => maxParticipants - registeredUsers.length;

  String get registrationStatus {
    if (!hasSpotsAvailable) return 'FULL';
    if (!DateTime.now().isBefore(registrationDeadline)) return 'CLOSED';
    return 'OPEN';
  }

  Color getStatusColor() {
    if (!hasSpotsAvailable) return Colors.red;
    if (!DateTime.now().isBefore(registrationDeadline)) return Colors.orange;
    return Colors.green;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'location': location,
      'eventType': eventType,
      'registrationDeadline': Timestamp.fromDate(registrationDeadline),
      'maxParticipants': maxParticipants,
      'registeredUsers': registeredUsers,
      'organizer': organizer,
      'isVirtual': isVirtual,
      'meetingLink': meetingLink,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  factory FBLAEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FBLAEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      location: data['location'] ?? '',
      eventType: data['eventType'] ?? 'meeting',
      registrationDeadline: (data['registrationDeadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      maxParticipants: data['maxParticipants'] ?? 100,
      registeredUsers: List<String>.from(data['registeredUsers'] ?? []),
      organizer: data['organizer'] ?? '',
      isVirtual: data['isVirtual'] ?? false,
      meetingLink: data['meetingLink'],
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  /*
  factory FBLAEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FBLAEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
      location: data['location'] ?? '',
      eventType: data['eventType'] ?? 'meeting',
      registrationDeadline:
          (data['registrationDeadline'] as Timestamp).toDate(),
      maxParticipants: data['maxParticipants'] ?? 100,
      registeredUsers: List<String>.from(data['registeredUsers'] ?? []),
      organizer: data['organizer'] ?? '',
      isVirtual: data['isVirtual'] ?? false,
      meetingLink: data['meetingLink'],
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }*/
}
