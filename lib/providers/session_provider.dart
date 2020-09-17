import 'package:flutter/material.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/models/session.dart';

class SessionProvider extends ChangeNotifier {
  Session session;

  // Constructor
  SessionProvider() {
    Logger.magenta("SessionProvider >> Instance created!");
  }
  
  Future<bool> load() async {
    Logger.magenta("SessionProvider >> Loading data...");
    if (session == null) session = Session();
    await session.resume();
    return session.exists;
  }

  Future<void> updateDisplayName(String displayName) async {
    await session.updateDisplayName(displayName);
    notifyListeners();
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    await session.updatePhotoUrl(photoUrl);
    notifyListeners();
  }


  void notify() {
    Logger.magenta("SessionProvider >> Notifying listeners...");
    Logger.magenta("SessionProvider >> .. displayName: ${session.displayName}");
    Logger.magenta("SessionProvider >> .. photoUrl: ${session.photoUrl}");
    notifyListeners();
  }

}
