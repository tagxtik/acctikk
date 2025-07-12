import 'package:acctik/view/LoginPage/log.dart';
import 'package:acctik/view/StagePage/StagePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 

class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the stream to return a result
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in
          return StagePage(); // Replace with your home screen
        } else {
          // User is not logged in
          return Login(); // Replace with your login screen
        }
      },
    );
  }
}
