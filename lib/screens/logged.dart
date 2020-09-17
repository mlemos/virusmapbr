import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/dash_content_selector.dart';
import 'package:virusmapbr/components/dash_navigation_bar.dart';
import 'package:virusmapbr/providers/app_state_provider.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/providers/layers_provider.dart';
import 'package:virusmapbr/providers/location_permissions_provider.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/providers/updates_provider.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Logged Screen
// This widget builds the main interface of the app for logged (authenticated) users.

class Logged extends StatefulWidget {
  @override
  _LoggedState createState() => _LoggedState();
}

class _LoggedState extends State<Logged> with WidgetsBindingObserver {
  SessionProvider _sessionProvider;
  LocationPermissionsProvider _permissionsProvider;
  HealthDataProvider _healthDataProvider;
  UpdatesProvider _updatesProvider;
  LayersProvider _layersProvider;
  AppStateProvider _appStateProvider;

  @override
  void initState() {
    Logger.yellow("Logged >> Initiating state...");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Logger.yellow("Logged >> State initiated!");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger.yellow("Logged >> AppLifeCycleState changed to ${state.toString()}");
    _appStateProvider?.setState(state);

    if (state == AppLifecycleState.resumed) {
      _permissionsProvider.checkPermissions();
      Logger.yellow(
          "Logged >> _updatesProvider.isRunning:  ${_updatesProvider.isRunning}");
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    Logger.white("Logged >> build()");

    _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    _appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
    _permissionsProvider =
        Provider.of<LocationPermissionsProvider>(context, listen: false);
    _healthDataProvider =
        Provider.of<HealthDataProvider>(context, listen: false);
    _updatesProvider = Provider.of<UpdatesProvider>(context, listen: false);
    _layersProvider = Provider.of<LayersProvider>(context, listen: false);

    return FutureBuilder<Object>(
      future: _prepareProviders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                body: Container(
                  child: DashContentSelector(),
                ),
                bottomNavigationBar: DashNavigationBar(),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: LinearProgressIndicator(),
              ),
            ),
            bottomNavigationBar: DashNavigationBar(),
          );
        }
      },
    );
  }

  Future<bool> _prepareProviders() async {
    Logger.yellow("Logged >> Preaparing providers...");
    var sessionExists = await _sessionProvider.load();
    await _healthDataProvider.load();
    _updatesProvider.start();
    await _layersProvider.start(context);
    return sessionExists;
  }
}
