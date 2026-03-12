import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_connect/entities/widgets/models/event_model.dart';
import 'package:fbla_connect/services/notification/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _events => _firestore.collection('events');

  

  Stream<List<FBLAEvent>> getUpcomingEvents() {
    final now = DateTime.now();
    return _events
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FBLAEvent.fromFirestore(doc))
            .toList());
  }

  Stream<List<FBLAEvent>> getAllEvents() {
  return _events
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FBLAEvent.fromFirestore(doc))
          .toList());
  }
  

  Stream<List<FBLAEvent>> getEventsByType(String type) {
    final now = DateTime.now();
    return _events
        .where('eventType', isEqualTo: type)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FBLAEvent.fromFirestore(doc))
            .toList());
  }

  Future<FBLAEvent?> getEventById(String eventId) async {
    final doc = await _events.doc(eventId).get();
    if (!doc.exists) return null;
    return FBLAEvent.fromFirestore(doc);
  }

  Stream<List<FBLAEvent>> getMyEvents() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _events
        .where('registeredUsers', arrayContains: userId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FBLAEvent.fromFirestore(doc))
            .toList());
  }

  Future<void> createEvent(FBLAEvent event) async {
    await _events.add(event.toMap());
  }


  Future<void> registerForEvent(String eventId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final eventRef = _events.doc(eventId);
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(eventRef);
      if (!snapshot.exists) throw Exception('Event not found');

      final registeredUsers = List<String>.from(snapshot['registeredUsers'] ?? []);
      final maxParticipants = snapshot['maxParticipants'] ?? 100;
      final eventData = snapshot.data() as Map<String, dynamic>;
      final eventTitle = eventData['title'] ?? 'Event';
      final eventDate = (eventData['date'] as Timestamp).toDate();
      final eventLocation = eventData['location'];

      if (registeredUsers.contains(userId)) {
        throw Exception('Already registered');
      }
      if (registeredUsers.length >= maxParticipants) {
        throw Exception('Event is full');
      }

      transaction.update(eventRef, {
        'registeredUsers': FieldValue.arrayUnion([userId])
      });
      final notificationService = NotificationService();
      
      await notificationService.showImmediateNotification(
        title: 'Registered: $eventTitle',
        body: 'You’re all set! Check your calendar for details.',
      );

      await notificationService.scheduleReminder(
        eventId: eventId,
        eventTitle: eventTitle,
        eventTime: eventDate,
        reminderBefore: const Duration(hours: 24),
        location: eventLocation,
      );

      await notificationService.scheduleReminder(
        eventId: eventId,
        eventTitle: eventTitle,
        eventTime: eventDate,
        reminderBefore: const Duration(hours: 1),
        location: eventLocation,
      );

      await notificationService.scheduleReminder(
        eventId: eventId,
        eventTitle: eventTitle,
        eventTime: eventDate,
        reminderBefore: const Duration(minutes: 0),
        location: eventLocation,
      );
    });
  }

  Future<void> unregisterFromEvent(String eventId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    await _events.doc(eventId).update({
      'registeredUsers': FieldValue.arrayRemove([userId])
    });

    await NotificationService().cancelEventReminders(eventId);
    
    await NotificationService().showImmediateNotification(
      title: 'Registration Cancelled',
      body: 'You have been removed from the event.',
    );
  }
  

  Future<void> updateEvent(String eventId, Map<String, dynamic> updates) async {
    await _events.doc(eventId).update(updates);
  }
  Future<void> deleteEvent(String eventId) async {
    await _events.doc(eventId).delete();
  }

  static List<String> getEventTypes() {
    return [
      'competition',
      'meeting',
      'workshop',
      'social',
      'service',
      'fundraiser',
    ];
  }

  static String formatEventType(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }
  void dispose() {
    print("EventService disposed");
  }
}