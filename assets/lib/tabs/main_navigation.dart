import 'package:fbla_connect/entities/widgets/clickable_Surfaces/floating_navbar.dart';
import 'package:fbla_connect/tabs/news_tab.dart';
import 'package:fbla_connect/tabs/social_tab.dart';
import 'package:flutter/material.dart';
import 'package:fbla_connect/tabs/home_tab.dart';
import 'package:fbla_connect/tabs/calendar_tab.dart';
import 'package:fbla_connect/tabs/resources_tab.dart';
import 'package:fbla_connect/tabs/profile_tab.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const CalendarTab(),
    const ResourcesTab(),
    const ProfileTab(),
    const SocialTab(), 
    const NewsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container( 
        margin: const EdgeInsets.only(bottom: 16), 
        child: FloatingNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}