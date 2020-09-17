import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/models/session.dart';
import 'package:virusmapbr/providers/providers_setup.dart';
import 'package:virusmapbr/screens/get_name.dart';
import 'package:virusmapbr/screens/news.dart';
import 'package:virusmapbr/screens/phone_auth.dart';
import 'package:virusmapbr/screens/phone_sign_in.dart';
import 'package:virusmapbr/screens/welcome.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/screens/onboard.dart';
import 'package:virusmapbr/screens/login_options.dart';
import 'package:virusmapbr/screens/logged.dart';
import 'package:firebase_core/firebase_core.dart';

// Main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.white("");
  Logger.white("Main >> Welcome to you app!");
  Logger.white("");
  await Firebase.initializeApp();
  final initialRoute = await _initialRoute();
  runApp(VirusMapBRApp(initialRoute));
}

// Defines the initial route depending on having a session or not.
Future<String> _initialRoute() async {
  Session session = Session();
  await session.resume();
  //await Jiffy.locale("pt");
  var initialRoute = (session.exists) ? "logged" : "onboarding";
  Logger.white("Main >> Initial route is: $initialRoute");
  return initialRoute;
}

// VirusMapBR App
class VirusMapBRApp extends StatelessWidget {
  final String initialRoute;
  VirusMapBRApp(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    Logger.white("VirusMapBRApp >> build()");
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VirusMapBR',
        darkTheme: VirusMapBRTheme.getTheme(Brightness.dark),
        theme: VirusMapBRTheme.getTheme(Brightness.light),
        initialRoute: initialRoute,
        routes: {
          "onboarding": (context) => Onboard(),
          "login": (context) => LoginOptions(),
          "phone_auth": (context) => PhoneAuth(),
          "phone_sign_in": (context) => PhoneSignIn(),
          "welcome": (context) => Welcome(),
          "get_name": (context) => GetName(),
          "logged": (context) => Logged(),
          "news": (context) => News(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          Locale("pt"),
        ],
      ),
    );
  }
}
