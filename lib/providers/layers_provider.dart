import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:virusmapbr/helpers/geo_calculator.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Provider responsible to provide information layers for the map.
// Currently only markers are provided, but may be extended for
// other layers such as heatmaps and markers clusters.

class LayersProvider with ChangeNotifier {
  bool _running = false;
  BuildContext _context;
  CameraPosition _cameraPosition;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Geoflutterfire _geo = Geoflutterfire();
  StreamSubscription<List<DocumentSnapshot>> _pingsStream;
  Map<String, BitmapDescriptor> _markersBitmaps = {};
  Set<Marker> _markers = {};
  AppLifecycleState _appState;

  // Getters and Setters
  Set<Marker> get markers => _markers;
  CameraPosition get cameraPosition => _cameraPosition;
  double get zoomLevel {
    if (_cameraPosition != null) return _cameraPosition.zoom;
    return null;
  }

  // Constructor
  LayersProvider() {
    Logger.magenta("LayersProvider >> Instance created!");
  }

  // Starts the provider (load markers bitmaps).
  Future<bool> start(BuildContext context) async {
    _context = context;
    if (!_running) {
      Logger.magenta("LayersProviders >> Starting the engines...");
      _running = true;
      await _loadCustomMarkersBitmaps();
    } else {
      Logger.magenta("LayersProviders >> Already running (start ignored)");
    }
    return true;
  }

  // Stops the provider and releases the stream.
  void stop() async {
    if (_running) {
      Logger.magenta("LayersProviders >> Stopping the engines...");
      _running = false;
      await _pingsStream?.cancel();
    }
  }

  // Sets the camera position.
  void setCameraPosition(CameraPosition position) {
    _cameraPosition = position;
    Logger.magenta(
        "LayersProviders >> Camera position set to (${_cameraPosition.target.latitude},${_cameraPosition.target.longitude}).");
    _handleCameraPositionChange();
  }


  void setAppState(AppLifecycleState state, BuildContext context) {
    _appState = state;
    Logger.red(
        "LayersProviders >> AppState is $state");

    if ((_appState == null) || (_appState == AppLifecycleState.resumed)) {
      start(context);
    } else {
      stop();
    }
  }

  // Handles the camera position changes.
  void _handleCameraPositionChange() {
    if (_running) {
      Logger.magenta("LayersProviders >> Handling camera move...");
      _subscribeToPings();
    } else {
      Logger.red("LayersProviders >> Ignored (not running)!");
    }
  }

  // Subscribe to pings from firebase.
  void _subscribeToPings() {
    Logger.magenta("LayersProviders >> Subscribing to pings...");
    _pingsStream?.cancel();
    var collectionReference = _firestore.collectionGroup('users');
    GeoFirePoint center = _geo.point(
        latitude: _cameraPosition.target.latitude,
        longitude: _cameraPosition.target.longitude);
    double radius = GeoCalculator.zoomToKm(_context, _cameraPosition.zoom) / 2;
    _pingsStream = _geo
        .collection(collectionRef: collectionReference)
        .within(
          center: center,
          radius: radius,
          field: 'position',
          strictMode: true,
        )
        .listen(_updateMarkers);
    Logger.magenta("LayersProviders >> ... Radius: ${radius}Km");
    Logger.magenta(
        "LayersProviders >> ... Center: (${_cameraPosition.target.latitude},${_cameraPosition.target.longitude})");
    Logger.magenta("LayersProviders >> Subscribed to pings!");
  }

  // Updates the makers based on query results.
  Future<void> _updateMarkers(List<DocumentSnapshot> documentList) async {
    Logger.magenta("LayersProviders >> Updating markers...");
    int n = 0;
    _markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      String covidHealthStatus = document.data()['healthData']['covidHealthStatus'];
      GeoPoint pos = document.data()['position']['geopoint'];
      var marker = Marker(
        markerId: MarkerId("marker_$n"),
        position: LatLng(pos.latitude, pos.longitude),
        icon: _markersBitmaps[covidHealthStatus],
        infoWindow: InfoWindow.noText,
      );
      _markers.add(marker);
      n++;
    });
    Logger.magenta("LayersProviders >> ... $n markers added");
    Logger.magenta("LayersProviders >> Markers updated!");
    notifyListeners();
  }

  // Loads the custom markers bitmaps from assets.
  Future<void> _loadCustomMarkersBitmaps() async {
    Logger.magenta("LayersProvider >> Loading custom markers bitmaps...");
    Map<String, String> covidStatusToColor = {
      "unknown": "grey",
      "suspect": "yellow",
      "confirmed": "red",
      "recovered": "green",
      "immune": "blue",
    };
    String brightness;
    if (Theme.of(_context).brightness == Brightness.light) {
      brightness = "light";
    } else {
      brightness = "dark";
    }
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(_context);
    for (var covidStatus in covidStatusToColor.keys) {
      var color = covidStatusToColor[covidStatus];
      _markersBitmaps[covidStatus] = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, "assets/$brightness-marker-$color.png");
    }
    Logger.magenta("LayersProvider >> Markers loaded!");
  }
}
