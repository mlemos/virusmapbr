import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virusmapbr/helpers/logger.dart';

class Session {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  String _userHash;

  // Getters and Setters
  String get userHash => _userHash;
  String get uid => _user.uid;
  String get displayName => _user.displayName;
  String get email => _user.email;
  String get phoneNumber => _user.phoneNumber;
  String get photoUrl => _user.photoURL;
  bool get exists => (_user != null);

  Session() {
    Logger.yellow("Session >> Instance created!");
  }

  // Try to resume an existing session.
  Future<void> resume() async {
    Logger.yellow("Session >> Resuming...");
    if (_user == null) _user = await _getFirebaseUser();
    if (_user == null) {
      Logger.red("Session >> .. Firebase user not found.");
      return null;
    }
    Logger.yellow("Session >> .. Firebase user found.");
    await _calculateUserHash();
    _log();
  }

  // Starts a session.
  // Assumes the session was already iniatiated by Firebase auth services.
  Future<void> start() async {
    // Get the Firebase session data.
    _user = await _getFirebaseUser();
    assert(_user != null);
    await _calculateUserHash();
    Logger.yellow("Session >> Session started!");
    _log();
  }

  // Calculate the session specific user hash (anonymous).
  Future<void> _calculateUserHash() async {
    Digest userHashDigest;
    String localSeed;
    try {
      localSeed = await DeviceId.getID;
    } catch (e) {
      localSeed = "";
    }
    userHashDigest = sha1.convert(utf8.encode(_user.uid + ":" + localSeed));
    _userHash = userHashDigest.toString();
  }

  // Finishes the current session and clear its data on SharedPreferences.
  Future<void> end() async {
    await _auth.signOut();
    Logger.yellow("Session >> Session ended!");
  }

  // Gets the current Firebase session data (if any).
  Future<User> _getFirebaseUser() async {
    User user = _auth.currentUser;
    return user;
  }

  Future<void> updateDisplayName(String displayName) async {
    await _user.updateProfile(displayName: displayName);    
    _user = _auth.currentUser;
    Logger.yellow("Session >> DisplayName changed to ${_user.displayName}.");
  }

  Future<void> updatePhotoUrl(String photoURL) async {
    await _user.updateProfile(photoURL: photoURL);
    _user = _auth.currentUser;
    Logger.yellow("Session >> Photo URL changed to ${_user.photoURL}.");
  }

  // Logs session map data.
  void _log() {
    Logger.yellow("Session >> .. userHash    : $_userHash");
    Logger.yellow("Session >> .. displayName : $displayName");
    Logger.yellow("Session >> .. email       : $email");
    Logger.yellow("Session >> .. phoneNumber : $phoneNumber");
    Logger.yellow("Session >> .. uid         : $uid");
  }
}
