import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    await _requestPermissions();

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
    } else if (defaultTargetPlatform == TargetPlatform.android) {
    }
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
          'fbla_channel',
          'FBLA Notifications',
          channelDescription: 'Notifications for FBLA events and updates',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );
    
    const DarwinNotificationDetails iosDetails = 
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Future<void> scheduleReminder({
    required String eventId,
    required String eventTitle,
    required DateTime eventTime,
    required Duration reminderBefore,
    String? location,
  }) async {
    final scheduledTime = eventTime.subtract(reminderBefore);
    
    if (scheduledTime.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      'fbla_reminders',
      'Event Reminders',
      channelDescription: 'Reminders for your registered FBLA events',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String reminderText;
    if (reminderBefore == const Duration(hours: 24)) {
      reminderText = 'Tomorrow at ${_formatTime(eventTime)}';
    } else if (reminderBefore == const Duration(hours: 1)) {
      reminderText = 'In 1 hour';
    } else if (reminderBefore == const Duration(minutes: 0)) {
      reminderText = 'Starting now';
    } else {
      reminderText = '${reminderBefore.inHours} hours before';
    }

    int notificationId;
    if (reminderBefore == const Duration(hours: 24)) {
      notificationId = eventId.hashCode + 24;
    } else if (reminderBefore == const Duration(hours: 1)) {
      notificationId = eventId.hashCode + 1;
    } else {
      notificationId = eventId.hashCode;
    }

    await _localNotifications.zonedSchedule(
      id: notificationId,
      title: eventTitle,
      body: '$reminderText ${location != null ? '· $location' : ''}',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: eventId,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelEventReminders(String eventId) async {
    await _localNotifications.cancel(id: eventId.hashCode + 24);
    await _localNotifications.cancel(id: eventId.hashCode + 1);
    await _localNotifications.cancel(id: eventId.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}