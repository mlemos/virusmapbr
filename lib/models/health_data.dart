import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/services/firebase_analytics.dart';

// HealthData model
// Represents the user health information.
// At construction tries to read existing data from SharedPreferences
// and from Firestores. If any, uses the most recent data.
// Otherwise starts a blank instance.

// userData/birthdate            : user's birthdate
// covidData/healthStatus        : indicates the status of this user
// covidData/hasSymptoms         : indicates if the user has any covid symptom
// covidData/hasCriticalSymptoms : indicates if the user has any critical covid symptom
// covidData/symptoms            : indicates the user's symptoms
// covidData/testStatus          : indicates if the user has taken the covid test
// covidData/testDate            : indicates when the test was realized
// covidData/testResult          : indicates the results of the user's covid test
// covidData/testResultDate      : indicates when the test results were received
// covidData/recovered           : indicates if the confirmed user has recovered from Covid
// covidData/recoveredDate       : indicates when the user recoveref from Covid
// covidData/immune              : indicates if the confirmed user has recovered from Covid
// covidData/immuneDate          : indicates when the user recoveref from Covid
// updatedAt                     : indicates the last time the data was updated

class HealthData {
  // Lists of values used across the app.

  static final Map<String, String> covidSymptomsDescriptions = {
    "highFever": "Febre alta",
    "dryCough": "Tosse seca",
    "shortnessOfBreath": "Dificuldade para respirar ou falta de ar",
    "fatigue": "Fadiga ou cansaço extremo",
    "soreThroat": "Garganta inflamada",
    "headaches": "Dores de cabeça",
    "achesAndPain": "Dores no corpo",
    "runnyNose": "Corrimento nasal",
    "diarrhea": "Diarréria",
  };

  static final List<String> covidCriticalSymptoms = [
    "highFever",
    "dryCough",
    "shortnessOfBreath",
    "fatigue",
  ];

  static final Map<String, String> covidHealthStatusDescriptions = {
    "unknown": "Desconhecido",
    "suspect": "Suspeito",
    "confirmed": "Confirmado",
    "recovered": "Recuperado",
    "immune": "Imune",
  };

  // HealthData attributes

  bool _loaded = false;
  String _userHash;
  DateTime birthdate;
  Map<String, bool> covidSymptoms = {
    "highFever": false,
    "dryCough": false,
    "shortnessOfBreath": false,
    "fatigue": false,
    "soreThroat": false,
    "headaches": false,
    "achesAndPain": false,
    "runnyNose": false,
    "diarrhea": false,
  };
  bool covidTestStatus;
  DateTime covidTestDate;
  bool covidTestResult;
  DateTime covidTestResultDate;
  bool covidRecovered;
  DateTime covidRecoveredDate;
  bool covidImmune;
  DateTime covidImmuneDate;
  DateTime updatedAt;
  bool shareWithDesviralize;

  // Getters and Setters
  String get covidHealthStatus {
    String _status = "unknown";
    if (covidHasSymptoms) _status = "suspect";
    if (covidTestStatus ?? false) {
      _status = "suspect";
      if (covidTestResult ?? false) {
        _status = "confirmed";
        if (covidRecovered ?? false) _status = "recovered";
        if (covidImmune ?? false) _status = "immune";
      } else {
        if (!(covidTestResult == null) && (!covidHasSymptoms))
          _status = "unknown";
      }
    }
    return _status;
  }

  bool get covidHasSymptoms {
    bool _has = false;
    for (var key in covidSymptoms.keys) {
      _has = _has || (covidSymptoms[key] ?? false);
    }
    return _has;
  }

  bool get covidHasCriticalSymptoms {
    bool _has = false;
    for (var key in covidCriticalSymptoms) {
      _has = _has || (covidSymptoms[key] ?? false);
    }
    return _has;
  }

  // Loads existing data from SharedPreferences or Firestore,
  // whichever is the most recent one.
  // If data is not available, starts a blank instance.
  Future<void> load(String userHash) async {
    Logger.green("HealthData >> Loading initial data:");
    assert(userHash != null);
    _userHash = userHash;

    // Avoid reloading the data
    if (_loaded) {
      Logger.green("HealthData >> .. Already loaded. Ignoring...");
      return true;
    }


    // Checking (local) SharedPreferences data.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefsUpdatedAt = _getPrefsDateTime(prefs, "updatedAt");
    Logger.green("HealthData >> .. local updatedAt : $prefsUpdatedAt");

    // Checking (remote) Firebase data
    DateTime firebaseUpdatedAt;
    Map<String, dynamic> firebaseDocument;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("users").doc(_userHash);
    DocumentSnapshot snapshot = await docRef.get();
  
    String source;
    if (snapshot.exists) {
      firebaseUpdatedAt = _getFirebaseDateTime(snapshot.data()["updatedAt"]);
      firebaseDocument = snapshot.data();
      source = (snapshot.metadata.isFromCache) ? "cache" : "server";
    }
    Logger.green("HealthData >> .. remote updatedAt: $firebaseUpdatedAt");
    Logger.green("HealthData >> .. remote source   : $source");

    // Decides which data set to use
    if (prefsUpdatedAt == null && firebaseUpdatedAt == null) {
      // Use default (blank) values.
      Logger.green("HealthData >> .. using default (blank) values...");
    } else if (prefsUpdatedAt != null && firebaseUpdatedAt != null) {
      if (firebaseUpdatedAt.isAfter(prefsUpdatedAt)) {
        // Firebase is newer
        Logger.green("HealthData >> .. remote is newer...");
        _loadFromFirebase(firebaseDocument);
      } else {
        // SharedPreferences is newer (or equal)
        Logger.green("HealthData >> .. local is newer...");
        _loadFromSharedPreferences(prefs);
      }
    } else if (prefsUpdatedAt != null) {
      // Use SharedPrefs (is the one that exists)
        Logger.green("HealthData >> .. only local found...");
      _loadFromSharedPreferences(prefs);
    } else {
      // Use Firebase (is the one that exists)
        Logger.green("HealthData >> .. only remote found...");
      _loadFromFirebase(firebaseDocument);
    }

    _log();
    _loaded = true;
    Logger.green("HealthData >> Loaded!");
    return true;
  }

  // Loads data from SharedPreferences
  void _loadFromSharedPreferences(SharedPreferences prefs) {
    Logger.green("HealthData >> .. loading local data...");
    birthdate = _getPrefsDateTime(prefs, "birthdate");
    for (var symptom in covidSymptomsDescriptions.keys) {
      covidSymptoms[symptom] = prefs.getBool("covidSymptom_$symptom");
    }
    covidTestStatus = prefs.getBool("covidTestStatus");
    covidTestDate = _getPrefsDateTime(prefs, "covidTestDate");
    covidTestResult = prefs.getBool("covidTestResult");
    covidTestResultDate = _getPrefsDateTime(prefs, "covidTestResultDate");
    covidRecovered = prefs.getBool("covidRecovered");
    covidRecoveredDate = _getPrefsDateTime(prefs, "covidRecoveredDate");
    covidImmune = prefs.getBool("covidImmune");
    covidImmuneDate = _getPrefsDateTime(prefs, "covidImmuneDate");
    updatedAt = _getPrefsDateTime(prefs, "updatedAt");
    shareWithDesviralize = prefs.getBool("shareWithDesviralize");
  }

  // Loads data from Firebase
  void _loadFromFirebase(Map<String, dynamic> document) async {
    Logger.green("HealthData >> .. loading remote data...");
    birthdate = _getFirebaseDateTime(document["userData"]["birthdate"]);
    for (var symptom in covidSymptomsDescriptions.keys) {
      covidSymptoms[symptom] = document["healthData"]["covidSymptom_$symptom"];
    }
    covidTestStatus = document["healthData"]["covidTestStatus"];
    covidTestDate =
        _getFirebaseDateTime(document["healthData"]["covidTestDate"]);
    covidTestResult = document["healthData"]["covidTestResult"];
    covidTestResultDate =
        _getFirebaseDateTime(document["healthData"]["covidTestResultDate"]);
    covidRecovered = document["healthData"]["covidRecovered"];
    covidRecoveredDate =
        _getFirebaseDateTime(document["healthData"]["covidRecoveredDate"]);
    covidImmune = document["healthData"]["covidImmune"];
    covidImmuneDate =
        _getFirebaseDateTime(document["healthData"]["covidImmuneDate"]);
    updatedAt = _getFirebaseDateTime(document["updatedAt"]);
    shareWithDesviralize = document["userData"]["shareWithDesviralize"];
  }

  DateTime _getPrefsDateTime(SharedPreferences prefs, String key) {
    String value = prefs.getString(key);
    if (value != null && value != "null") {
      return DateTime.parse(value);
    }
    return null;
  }

  DateTime _getFirebaseDateTime(Timestamp timestamp) {
    if (timestamp != null) {
      return timestamp.toDate();
    }
    return null;
  }

  // Saves data in SharedPreferences
  Future<void> save() async {
    Logger.green("HealthData >> Saving HealthData in SharedPreferences...");
    firebaseLogEvent("healthdata_save");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("birthdate", birthdate.toString());
    for (var symptom in covidSymptomsDescriptions.keys) {
      prefs.setBool("covidSymptom_$symptom", covidSymptoms[symptom]);
    }
    prefs.setBool("covidTestStatus", covidTestStatus);
    prefs.setString("covidTestDate", covidTestDate.toString());
    prefs.setBool("covidTestResult", covidTestResult);
    prefs.setString("covidTestResultDate", covidTestResultDate.toString());
    prefs.setBool("covidRecovered", covidRecovered);
    prefs.setString("covidRecoveredDate", covidRecoveredDate.toString());
    prefs.setBool("covidImmune", covidImmune);
    prefs.setString("covidImmuneDate", covidImmuneDate.toString());
    updatedAt = DateTime.now();
    prefs.setString("updatedAt", updatedAt.toString());
    prefs.setBool("shareWithDesviralize", shareWithDesviralize);
    Logger.green("HealthData >> Data saved!");
  }

  void _log() {
    Logger.green("HealthData >> .. ${covidHealthStatus.toUpperCase()} >> " +
        "${(covidHasSymptoms) ? "SYMPTOMS" : "NO SYMPTOMS"} >> " +
        "${(covidHasCriticalSymptoms) ? "CRITICAL" : "NO CRITICAL"}");
    Logger.green(
        "HealthData >> .. birthdate           : " + birthdate.toString());
    Logger.green("HealthData >> .. covidSymptoms       : " +
        covidSymptoms.values.map((i) => ((i) ? "x" : "-")).join());
    Logger.green(
        "HealthData >> .. covidTestStatus     : " + covidTestStatus.toString());
    Logger.green(
        "HealthData >> .. covidTestDate       : " + covidTestDate.toString());
    Logger.green(
        "HealthData >> .. covidTestResult     : " + covidTestResult.toString());
    Logger.green("HealthData >> .. covidTestResultDate : " +
        covidTestResultDate.toString());
    Logger.green(
        "HealthData >> .. covidRecovered      : " + covidRecovered.toString());
    Logger.green("HealthData >> .. covidRecoveredtDate : " +
        covidRecoveredDate.toString());
    Logger.green(
        "HealthData >> .. covidImmune         : " + covidImmune.toString());
    Logger.green(
        "HealthData >> .. covidImmuneDate     : " + covidImmuneDate.toString());
    Logger.green(
        "HealthData >> .. updatedAt           : " + updatedAt.toString());
    Logger.green(
        "HealthData >> .. shareWithDesviralize: " + shareWithDesviralize.toString());
  }
}
