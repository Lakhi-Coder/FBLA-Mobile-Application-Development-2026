import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/firebase_options.dart';
import 'package:fbla_connect/services/authentication/auth_check.dart';
import 'package:fbla_connect/services/events/events.dart'; 
import 'package:fbla_connect/services/events/seed_events.dart';
import 'package:fbla_connect/tabs/calendar_tab.dart';
import 'package:fbla_connect/tabs/getstarted_tab.dart';
import 'package:fbla_connect/tabs/main_navigation.dart';
import 'package:fbla_connect/tabs/news_tab.dart';
import 'package:fbla_connect/tabs/profile_tab.dart';
import 'package:fbla_connect/tabs/social_tab.dart'; 
import 'package:fbla_connect/tabs/resources_tab.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
    );
    print("Firebase initialized successfully");  
  } catch (e) {
    print("Firebase initialization error: $e"); 
  }
  await seedFBLAEvents();
  runApp(const FblaMobileApp()); 
}

class FblaMobileApp extends StatelessWidget {
  const FblaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventService>(
          create: (_) => EventService(),
          dispose: (_, service) => service.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'FBLA Connect',
        theme: ThemeData(
          primaryColor: uniqueTertiaryColor,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
        ),
        home: Scaffold(body: const AuthCheck()),
        routes: {
          '/profile': (context) => const ProfileTab(),
          '/calendar': (context) => const CalendarTab(), 
          '/resources': (context) => const ResourcesTab(), 
          '/social': (context) => const SocialTab(), 
          '/news': (context) => const NewsTab(), 
          '/getstarted': (context) => GetstartedTab(), 
          '/main': (context) => const MainNavigation(), 
        },
      ),
    );
  }
}