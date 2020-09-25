import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_e_commerce/screens/home_page.dart';
import 'package:flutter_e_commerce/screens/login_page.dart';

import '../constants.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if snapshot.haserror
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error :${snapshot.error}"),
            ),
          );
        }

        //Connection Initialized - Firebase App is runing
        if (snapshot.connectionState == ConnectionState.done) {
          //check the state of login live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              //if streamSnapshot.haserror
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error :${streamSnapshot.error}"),
                  ),
                );
              }

              // connnection state active - Do the user login check indide
              //the if statement
              if (streamSnapshot.connectionState == ConnectionState.active) {
                //get the login user
                User _user = streamSnapshot.data;

                //if the user is null were not logged in
                if (_user == null) {
                  // user not logged in
                  return LogingPage();
                } else {
                  // THE USER IS LOGGED IN HEAD TO HOMEPAGE
                  return Homepage();
                }
              }

              // Checking the authstate - loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication ...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        //Connection to firebase - loading
        return Scaffold(
          body: Center(
            child: Text(
              "Initializing App ...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
