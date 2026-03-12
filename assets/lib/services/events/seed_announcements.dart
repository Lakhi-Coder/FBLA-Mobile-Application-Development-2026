import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedAnnouncements() async {
  final firestore = FirebaseFirestore.instance;

  final existing = await firestore.collection('announcements').limit(1).get();
  if (existing.docs.isNotEmpty) {
    print('Announcements already seeded. Skipping...');
    return;
  }

  final now = DateTime.now();
  final announcements = [
    {
      'title': 'State Conference Registration Deadline Extended',
      'content': 'Good news! The registration deadline for the State Leadership Conference has been extended to March 15th. This is your LAST CHANCE to register. Don\'t miss out on this amazing opportunity to compete and network with FBLA members from across the state!',
      'authorId': 'system',
      'authorName': 'State Officer Team',
      'authorPhotoUrl': null,
      'priority': 'urgent',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(hours: 2))),
      'readBy': [],
    },
    {
      'title': 'Competition Schedule Changes',
      'content': 'Due to venue availability, the Mobile App Development and Public Speaking competitions have been moved to Room 204 and 205 respectively. Please check the updated schedule posted in the main hallway. We apologize for any inconvenience.',
      'authorId': 'system',
      'authorName': 'Events Committee',
      'authorPhotoUrl': null,
      'priority': 'urgent',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
      'readBy': [],
    },

    {
      'title': 'Mandatory Officer Meeting',
      'content': 'All chapter officers must attend a mandatory planning meeting this Friday at 3:30 PM in the Media Center. We will be discussing end-of-year events and the transition for next year\'s officer team. Attendance is required.',
      'authorId': 'system',
      'authorName': 'Chapter Advisor',
      'authorPhotoUrl': null,
      'priority': 'important',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 3))),
      'readBy': [],
    },
    {
      'title': 'Fundraiser Update',
      'content': 'Our Krispy Kreme fundraiser raised over \$500! Thank you to everyone who participated and helped sell donuts. Proceeds will go toward state conference registration fees. Pick up your prizes at the next chapter meeting.',
      'authorId': 'system',
      'authorName': 'Fundraising Chair',
      'authorPhotoUrl': null,
      'priority': 'important',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
      'readBy': [],
    },
    {
      'title': 'Practice Test Session',
      'content': 'We will be holding a practice test session for all objective test events this Wednesday from 3:30-5:00 PM in Room 112. Bring your study materials and any questions. This is a great opportunity to prepare for regionals!',
      'authorId': 'system',
      'authorName': 'Competitive Events VP',
      'authorPhotoUrl': null,
      'priority': 'important',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 7))),
      'readBy': [],
    },

    {
      'title': 'Chapter Photo This Friday',
      'content': 'We will be taking the annual chapter photo this Friday at 3:00 PM on the front steps. Please wear your FBLA blazers if you have them. This photo will be used in the yearbook and on our chapter website.',
      'authorId': 'system',
      'authorName': 'Historian',
      'authorPhotoUrl': null,
      'priority': 'normal',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 10))),
      'readBy': [],
    },
    {
      'title': 'Welcome New Members',
      'content': 'A big welcome to our 15 new members who joined this month! We\'re excited to have you in FBLA. Please introduce yourself at the next meeting and let us know which competitive events interest you.',
      'authorId': 'system',
      'authorName': 'Membership VP',
      'authorPhotoUrl': null,
      'priority': 'normal',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 14))),
      'readBy': [],
    },
    {
      'title': 'Pizza Social Next Week',
      'content': 'Join us for a pizza social next Tuesday after school in the Student Lounge. This is a great chance to get to know other members and relax after midterms. Please RSVP so we can order enough food.',
      'authorId': 'system',
      'authorName': 'Social Committee',
      'authorPhotoUrl': null,
      'priority': 'normal',
      'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 20))),
      'readBy': [],
    },
  ];

  for (var announcement in announcements) {
    await firestore.collection('announcements').add(announcement);
  }

  print('Sample announcements seeded!');
}