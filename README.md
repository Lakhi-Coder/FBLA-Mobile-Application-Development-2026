# FBLA Connect – Official FBLA Member App

![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-10.25-orange?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Table of Contents

- [The Problem We Solved](#the-problem-we-solved)
- [Our Solution](#our-solution)
- [Key Features (Aligned with FBLA Rubric)](#key-features-aligned-with-fbla-rubric)
- [Tech Stack & Architecture](#tech-stack--architecture)
- [Development Process](#development-process)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Future Enhancements](#future-enhancements)
- [Credits & Acknowledgements](#credits--acknowledgements)
- [License](#license)

---

## The Problem We Solved

As FBLA members, we experienced firsthand how scattered information affects our chapter. Competition deadlines hide in emails, resources are spread across Google Drive, and announcements come through multiple apps (GroupMe, Instagram, Remind). Members miss important dates, officers spend hours on manual tracking, and advisors struggle to keep everyone engaged.

We built **FBLA Connect** to answer one question:

> **What if everything an FBLA member needs was in one place?**

---

## Our Solution

**FBLA Connect** is a cross-platform mobile app that unifies chapter management, event participation, and leadership development into a single, intuitive experience. Built with **Flutter** and **Firebase**, it runs on **iOS, Android, and the web** – so members stay connected whether in class, at a competition, or on the go.

We created a system that mirrors real chapter operations with **role-based access** for members, officers, and advisors.

---

## Key Features (Aligned with FBLA Rubric)

### Member Profiles

- Complete profiles with name, email, chapter number, role, grade level, and optional photo
- Achievements and service hours tracking – badges earned for participation
- Verified status for advisors and officers

### Smart Event Calendar & Reminders

- Interactive calendar using `table_calendar` (day, week, month views)
- Firestore-powered events with real-time updates
- Registration system with spot limits and attendee lists
- Filter events by type: competition, meeting, workshop, social, service, fundraiser
- Toggle between **all events** and **only upcoming events**

#### Local Notifications (Reminders)

- Immediate confirmation after registration
- 24-hour reminder before the event
- 1-hour reminder
- "Starting now" notification

> All notifications are scheduled locally and work offline – no paid Apple account required.

### Resource Library

- Official FBLA 2025–2026 documents: competitive event guidelines, national bylaws, rating sheets
- Categorized resources for:
  - Competitive events (Mobile App Development, Public Speaking, Accounting, etc.)
  - Exam preparation (sample questions, topic guides)
  - Chapter management (handbooks, award programs)
- External links open in-app via `url_launcher`
- Offline caching of viewed resources

### News Feed with Priority System

- Real-time announcements from chapter officers and advisors
- Three priority levels with visual badges:
  - **Urgent** – red badge
  - **Important** – orange badge
  - **Normal** – blue badge
- Read/unread tracking per user
- Officers and advisors can create, edit, and delete announcements
- Filter by **all news** or **urgent only**

### Social Media Integration *(5-Point Feature)*

- **Direct YouTube Data API v3** integration – displays real FBLA videos with view counts, like counts, channel info, and publication dates
- One-click sharing of achievements, events, and resources via `share_plus`
- Quick-connect cards for major FBLA channels:
  - Instagram (`@fbla_national`)
  - Facebook (Future Business Leaders of America)
  - X / Twitter (`@FBLA_National`)
  - YouTube (FBLA National)
  - LinkedIn (Future Business Leaders of America)

### Role-Based Access Control

| Role | Permissions |
|---|---|
| **Member** | View events, register, update own profile, read announcements, share content |
| **Officer** | All member permissions + create events, award achievements, create announcements |
| **Advisor** | Full admin: change user roles, verify accounts, manage all content, delete anything |

### Data Persistence & Offline Support

- **Firestore** for users, events, resources, and announcements
- **Automatic caching** – events and resources remain accessible without internet
- Real-time sync when connection is restored

---

## Tech Stack & Architecture

| Layer | Technology |
|---|---|
| **Frontend** | Flutter 3.22 (Dart) – iOS, Android, Web |
| **State Management** | Provider + Riverpod |
| **Backend** | Firebase (Authentication, Firestore, Storage) |
| **Notifications** | `flutter_local_notifications` + `timezone` (local scheduling) |
| **Social API** | YouTube Data API v3 |
| **Sharing** | `share_plus` |
| **URL Handling** | `url_launcher` |
| **UI/UX** | Glassmorphism, custom animations, FBLA brand colors (`#003366` Navy, `#FFCC00` Gold) |

### Architecture Diagram

```
┌─────────────────────────────────────────────┐
│              Flutter Frontend               │
├─────────────────────────────────────────────┤
│  Member Profiles   │   Event Calendar       │
│  Resource Library  │   News Feed            │
│  Social Hub        │   Admin Panel          │
│  Local Notifications│  Role-Based UI        │
└───────────┬─────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────┐
│              Firebase Backend               │
├──────────────┬──────────────┬──────────────┤
│   Firebase   │    Cloud     │   Firebase   │
│   Auth       │  Firestore   │   Storage    │
│   (Email)    │  (Users,     │  (Profile    │
│              │   Events,    │   Images)    │
│              │   Resources, │              │
│              │  Announcements)             │
└──────────────┴──────────────┴──────────────┘
```

---

## Development Process

We followed an **Agile-inspired approach** with four main phases:

| Phase | Focus | Key Deliverables |
|---|---|---|
| 1 | Foundation | Firebase project setup, authentication, `FBLAUser` model, Firestore security rules |
| 2 | Core Features | Event calendar with `table_calendar`, registration system, resource library with real FBLA documents |
| 3 | Engagement | YouTube API integration, share buttons, role-based UI, news feed with priority system |
| 4 | Polish & Documentation | Local notification scheduling, offline support, comprehensive testing, README, code comments |

The entire project was developed by two people (me and my brother) – no external team. We maintained wireframes, conducted peer code reviews, and performed user testing with fellow chapter members.

---

## Getting Started

### Prerequisites

- Flutter SDK **3.22+**
- Firebase account (free tier)
- Xcode 15+ (for iOS development)
- Android Studio / IntelliJ (for Android)
- Physical iOS device for notification testing *(simulators do not show local notifications reliably)*

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Lakhi-Coder/FBLA-Mobile-Application-Development-2026.git
cd assets
```

**2. Install dependencies**

```bash
flutter pub get
```

### Firebase Configuration

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication → Email/Password**
3. Enable **Firestore Database** – start in test mode for development
4. Register your apps:
   - iOS: Bundle ID `com.yourname.fbla`
   - Android: Package name `com.yourname.fbla`
   - Web: *(optional)*
5. Download configuration files:
   - `GoogleService-Info.plist` → place in `ios/Runner/`
   - `google-services.json` → place in `android/app/`
6. Update Firestore Security Rules – use the rules provided in `/docs/firestore.rules`

### YouTube API Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable **YouTube Data API v3**
3. Create an API key
4. Add the key to `lib/services/youtube_service.dart`

### Local Notifications (iOS)

No special setup required – `flutter_local_notifications` handles permissions automatically. Ensure your iOS deployment target is at least **iOS 10**.

### Seed Sample Data *(Optional)*

In `main.dart`, temporarily uncomment the seed calls:

```dart
await seedFBLAEvents();
await seedAnnouncements();
```

Run the app once, then comment them out to avoid duplicates.

### Run the App

```bash
flutter run
```

---

## Testing

- Unit tests for authentication, Firestore services, and notification scheduling
- Integration tests covering full user flows: signup → browse events → register → receive local notification
- Tested on:

| Device | OS |
|---|---|
| iPhone 15 Pro | iOS 17 |
| Pixel 8 | Android 14 |

## Future Enhancements

- **In-app messaging** for chapter officers and study groups
- **QR code check-ins** for events to automatically award attendance badges
- **Machine learning recommendations** for events and resources based on user interests
- **Cross-chapter collaboration** features

---

## Credits & Acknowledgements

- **FBLA National** for the competitive event guidelines and the 2025–2026 topic
- **Code.org** for their partnership in shaping this year's prompt
- **Flutter, Firebase, Dart teams** for their excellent documentation and tools
- Our chapter advisor and fellow members who provided feedback during testing

> All icons, logos, and trademarks are used with permission or under applicable open-source licenses. Full source documentation and attributions are in the `/docs` folder.

---

## License

This project is created for educational purposes as part of the FBLA Mobile Application Development competition. It is not intended for commercial use.

See the [LICENSE](LICENSE.txt) file for details.

---

*FBLA Connect: One chapter. One platform. Any device.*
