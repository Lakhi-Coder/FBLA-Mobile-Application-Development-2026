import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fbla_connect/tabs/getstarted_tab.dart';
import 'package:fbla_connect/tabs/main_navigation.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasError) {
          print("Auth error: ${snapshot.error}");
          FirebaseAuth.instance.signOut();
          return GetstartedTab();
        }
        
        if (snapshot.hasData) {
          final user = snapshot.data;
          
          return FutureBuilder(
            future: user?.reload(),
            builder: (context, reloadSnapshot) {
              if (reloadSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (reloadSnapshot.error == null && 
                  FirebaseAuth.instance.currentUser != null) {
                return const MainNavigation();
              }
              
              FirebaseAuth.instance.signOut();
              return GetstartedTab();
            },
          );
        }
        
        return GetstartedTab();
      },
    );
  }
}