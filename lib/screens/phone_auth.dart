import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virusmapbr/screens/get_name.dart';
import 'package:virusmapbr/screens/phone_sign_in.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/screens/welcome.dart';

class PhoneAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _handleAuth(),
    );
  }

  Widget _handleAuth() {
    Logger.yellow("PhoneAuth >> Handling phone authentication...");
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data;
          Logger.yellow("PhoneAuth >> .. onAuthStateChanged has data...");
          Logger.yellow("PhoneAuth >> .. snapshot.data: ${user.toString}");
          if (user != null) {
            // We have a session, the user is logged.
            Logger.yellow("PhoneAuth >> .. User is logged!");
            if (user.displayName != null && user.displayName.isNotEmpty) {
              return Welcome();
            } else {
              return GetName();
            }
          } else {
            // We dont have a session, the user is not logged.
            Logger.yellow("PhoneAuth >> User is not logged!");
            return PhoneSignIn();
          }
        } else {
          Logger.yellow("PhoneAuth >> .. onAuthStateChanged has no data...");
          return PhoneSignIn();
        }
      },
    );
  }
}
