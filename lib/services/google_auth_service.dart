import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Google Authentication Service
// Uses Firebase to authenticate users with Google accounts.
class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    Logger.blue("GoogleAuthServices >> Signing in with Google...");
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    AuthCredential credential;
    UserCredential userCredential;
    User user;

    try {
      googleSignInAccount = await googleSignIn.signIn();
      Logger.blue("GoogleAuthServices >> .. signin is done...");
      googleSignInAuthentication = await googleSignInAccount.authentication;
      Logger.blue("GoogleAuthServices >> .. authentication is done...");
      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      Logger.blue("GoogleAuthServices >> .. credential get is done...");
      userCredential = await _auth.signInWithCredential(credential);
      Logger.blue("GoogleAuthServices >> .. firebase signin is done...");
      user = userCredential.user;
      Logger.blue("GoogleAuthServices >> .. user is: ${user.email}");
    } on PlatformException catch (e) {
      Logger.red("GoogleAuthService >> Authentication failed.");
      Logger.red("GoogleAuthService >> .. error: ${e.toString()}");
      return false;
    } catch (e) {
      Logger.red("GoogleAuthService >> Authentication failed.");
      Logger.red("GoogleAuthService >> .. error: ${e.toString()}");
      return false;
    }

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    //final User currentUser = await _auth.currentUser();
    //assert(user.uid == currentUser.uid);
    Logger.blue("GoogleAuthServices >> .. firebase user is the same of google...");
    Logger.blue("GoogleAuthServices >> All good!");

    return true;
  }
}
