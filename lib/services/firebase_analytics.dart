import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

void firebaseLogEvent(String event, {Map<String,dynamic> parameters}) {
  analytics.logEvent(name: "virusmapbr_$event", parameters: parameters);
}