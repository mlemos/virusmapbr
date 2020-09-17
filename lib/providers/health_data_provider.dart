import 'package:flutter/material.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/models/health_data.dart';
import 'package:virusmapbr/providers/session_provider.dart';

class HealthDataProvider extends ChangeNotifier {
  SessionProvider _sessionProvider;
  HealthData healthData = HealthData();
  bool _firstTime = true;
  bool _forceInstructions = false;
  bool hasResult = false;

  // Getters and Setters
  String get userHash => _sessionProvider.session.userHash;
  bool get firstTime {
    return (_firstTime && (healthData.updatedAt == null) || _forceInstructions);
  }

  set firstTime(bool firstTime) {
    if (firstTime == false) _forceInstructions = false; 
    _firstTime = firstTime;
    notifyListeners();
  }

  void forceInstructions() {
    _forceInstructions = true;
    notifyListeners();
  }

  // Constructor
  HealthDataProvider() {
    Logger.magenta("HealthDataProvider >> Instance created!");
  }

  void update(SessionProvider sessionProvider) {
    _sessionProvider = sessionProvider;
  }

  // Loads the HealthData from SharedPreferences or Firestore.
  Future<void> load() async {
    Logger.magenta("HealthDataProvider >> Loading data from $userHash ...");
    await healthData.load(userHash);
  }

  // Saves the HealthData in SharedPreferences and notifies listeners.
  Future<void> save({bool persist = true}) async {
    Logger.magenta("HealthDataProvider >> Updating...");
    if (persist) await healthData.save();
    notifyListeners();
  }
}
