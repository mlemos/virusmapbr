import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';

// Provider responsible to handle all updates made by the app.
// It listens for position changes and acts depending on the changes.
// It also receives notifications about changes in the health data
// and acts depeding on the changes.

class UpdatesProvider with ChangeNotifier {
  bool _running = false;
  StreamSubscription<Position> _positionStream;
  int _distanceFilter = 25;
  LatLng _lastPosition = LatLng(-10.0, -55.0);
  LatLng _currentPosition = LatLng(-10.0, -55.0);
  Timestamp _positionTimestamp;
  HealthDataProvider _healthDataProvider;
  Geoflutterfire _geo = Geoflutterfire();
  GeoFirePoint _geoPosition;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters and Setters
  LatLng get currentPosition => _currentPosition;
  bool get isRunning => _running;

  // Constructor
  UpdatesProvider() {
    Logger.magenta("UpdatesProvider >> Instance created!");
  }

  // Updater
  void update(HealthDataProvider healthDataProvider) {
    _healthDataProvider = healthDataProvider;
  }

  // Starts the background work (listen for changes).
  Future<bool> start() async {
    if (!_running) {
      _running = true;
      Logger.magenta("UpdatesProvider >> Starting the engines...");
      await _subscribeForPositionChanges();
      Logger.magenta("UpdatesProvider >> .. start: $_running");
    } else {
      Logger.magenta("UpdatesProvider >> Already running (start ignored).");
    }
    return true;
  }


  // Stops listenting for changes and releases the stream.
  void stop() async {
    if (_running) {
      Logger.magenta("UpdatesProvider >> Stopping the engines...");
      _running = false;
      await _positionStream?.cancel();
    } else {
      Logger.magenta("UpdatesProvider >> Already stopped (stop ignored).");
    }
  }

  // Sends a ping immediately.
  void updateNow() async {
    Logger.magenta("UpdatesProvider >> Updating now...");
    if (_running) {
      await _sendPing();
    } else {
      Logger.magenta("UpdatesProvider >> .. not running (ignored).");
    }
  }

  // Gets the status of the provider.
  Map getStatus() {
    var status = {
      "running": _running,
      "lastPosition": _lastPosition,
      "currentPosition": _currentPosition,
      "positionTimestamp": _positionTimestamp,
    };
    Logger.magenta("UpdatesProvider >> Status:");
    Logger.magenta("UpdatesProvider >> .. Running         : $_running");
    Logger.magenta(
        "UpdatesProvider >> .. LastPositions   : (${_lastPosition.latitude},${_lastPosition.longitude})");
    Logger.magenta(
        "UpdatesProvider >> .. CurrentPosition : (${_currentPosition.latitude},${_currentPosition.longitude})");
    Logger.magenta(
        "UpdatesProvider >> .. Timestamp       : $_positionTimestamp");
    return status;
  }

  // Subcribes for position changes within a distance filter.
  Future<void> _subscribeForPositionChanges() async {
    Logger.magenta("UpdatesProvider >> Subscribing for position changes...");
    await _positionStream?.cancel();
    _positionStream = getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: _distanceFilter).listen(
      (Position position) async => await _handlePositionChange(position),
      onError: (e) {
        Logger.red(
            "UpdatesProvider >> .. Subscription failed: ${e.toString()}");
        _running = false;
      },
    );
  }

  // Handles position changes.
  Future<void> _handlePositionChange(Position position) async {
    Logger.magenta(
        "UpdatesProvider >> Position changed to (${position.latitude},${position.longitude})");
    if (_currentPosition == null)
      Logger.magenta("UpdatesProvider >> Initial position found!");
    _lastPosition = _currentPosition;
    _currentPosition = LatLng(position.latitude, position.longitude);
    _positionTimestamp = Timestamp.now();
    notifyListeners();
    await _sendPing();
  }

  // Sends an update (ping) to firebase.
  Future<void> _sendPing() async {
    Logger.magenta("UpdatesProvider >> Sending ping...");
    await _send();
    Logger.magenta("UpdatesProvider >> Ping sent!");
  }

  // Send the data to the
  Future<void> _send() async {
    Logger.blue("UpdatesProvider >> Sending data to Firestore...");
    _geoPosition = _geo.point(
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude);
    // Build the coument
    var document = {
      'position': _geoPosition.data,
      'userData': {
        'birthdate': _healthDataProvider.healthData.birthdate,
        'shareWithDesviralize': _healthDataProvider.healthData.shareWithDesviralize,
      },
      'healthData': {
        'covidSymptom_highFever': _healthDataProvider.healthData.covidSymptoms['highFever'],
        'covidSymptom_dryCough': _healthDataProvider.healthData.covidSymptoms['dryCough'],
        'covidSymptom_shortnessOfBreath':
            _healthDataProvider.healthData.covidSymptoms['shortnessOfBreath'],
        'covidSymptom_fatigue': _healthDataProvider.healthData.covidSymptoms['fatigue'],
        'covidSymptom_soreThroat': _healthDataProvider.healthData.covidSymptoms['soreThroat'],
        'covidSymptom_headaches': _healthDataProvider.healthData.covidSymptoms['headaches'],
        'covidSymptom_achesAndPain': _healthDataProvider.healthData.covidSymptoms['achesAndPain'],
        'covidSymptom_runnyNose': _healthDataProvider.healthData.covidSymptoms['runnyNose'],
        'covidSymptom_diarrhea': _healthDataProvider.healthData.covidSymptoms['diarrhea'],
        'covidTestStatus': _healthDataProvider.healthData.covidTestStatus,
        'covidTestDate': _healthDataProvider.healthData.covidTestDate,
        'covidTestResult': _healthDataProvider.healthData.covidTestResult,
        'covidTestResultDate': _healthDataProvider.healthData.covidTestResultDate,
        'covidRecovered': _healthDataProvider.healthData.covidRecovered,
        'covidRecoveredDate': _healthDataProvider.healthData.covidRecoveredDate,
        'covidImmune': _healthDataProvider.healthData.covidImmune,
        'covidImmuneDate': _healthDataProvider.healthData.covidImmuneDate,
        'covidHealthStatus': _healthDataProvider.healthData.covidHealthStatus,
        'covidHasSymptoms': _healthDataProvider.healthData.covidHasSymptoms,
        'covidHasCriticalSymptoms': _healthDataProvider.healthData.covidHasCriticalSymptoms,
      },
      'updatedAt': _healthDataProvider.healthData.updatedAt,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(_healthDataProvider.userHash)
        .collection('pings')
        .add(document);
    await _firestore
        .collection('users')
        .doc(_healthDataProvider.userHash)
        .set(document);
    Logger.blue("Updates Provider >> Data sent!");
  }
}
