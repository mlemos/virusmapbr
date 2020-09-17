import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/geo_calculator.dart';
import 'package:virusmapbr/providers/app_state_provider.dart';
import 'package:virusmapbr/providers/layers_provider.dart';
import 'package:virusmapbr/providers/updates_provider.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Dash Map
// Presents a map with the hot zones (markers/clusters).
// Also points where the user is based on its device's location.

class DashMap extends StatefulWidget {
  @override
  _DashMapState createState() => _DashMapState();
}

class _DashMapState extends State<DashMap> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  CameraPosition _cameraPosition;
  bool _isLegendOn = false;
  bool _followPosition = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _legendController;
  LayersProvider _layersProvider;
  UpdatesProvider _updatesProvider;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    Logger.cyan("DashMap >> build()");
    return _buildFutureMap();
  }

  @override
  void initState() {
    super.initState();
    Logger.cyan("DashMap >> Initializing state...");
    _updatesProvider = Provider.of<UpdatesProvider>(context, listen: false);
    _updatesProvider.start(); // FIXME GB, isto é redundante?
    _updatesProvider.getStatus();
    _layersProvider = Provider.of<LayersProvider>(context, listen: false);

    _cameraPosition = CameraPosition(
      target: _updatesProvider.currentPosition,
      zoom: _layersProvider.zoomLevel ?? 15,
    );

    _layersProvider.setCameraPosition(_cameraPosition);

    Logger.cyan("DashMap >> .. Initial camera position:");
    Logger.cyan(
        "DashMap >> .... Target: (${_cameraPosition.target.latitude},${_cameraPosition.target.longitude})");
    Logger.cyan("DashMap >> .... Zoom: ${_cameraPosition.zoom}");
    Logger.cyan("DashMap >> .. Listening for position changes...");
    _updatesProvider.addListener(() {
      // Object changed (new position).
      if (_followPosition) {
        _cameraPosition = CameraPosition(
            target: _updatesProvider.currentPosition,
            zoom: _cameraPosition.zoom);
        _centerCamera();
      } else {
        Logger.cyan("DashMap >> .... Ignoring (not following positon)...");
      }
    });
    Logger.cyan("DashMap >> State initalized!");
  }

  // Builds the Google Maps widget.
  FutureBuilder<bool> _buildFutureMap() {
    final layersProvider = Provider.of<LayersProvider>(context);
    final appStateProvider = Provider.of<AppStateProvider>(context);
    layersProvider.setAppState(appStateProvider.state, context);

    return FutureBuilder(
      future: _prepareMap(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: VirusMapBRTheme.color(context, "background"),
            key: _scaffoldKey,
            body: GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              indoorViewEnabled: false,
              initialCameraPosition: _cameraPosition,
              markers: layersProvider.markers,
              onMapCreated: (GoogleMapController controller) =>
                  _handleMapCreated(controller),
              onCameraMove: (CameraPosition cameraPosition) =>
                  _handleCameraMove(cameraPosition),
              onCameraIdle: () => _handleCameraIdle(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildMapControls(),
          );
        } else {
          return Container(
            color: VirusMapBRTheme.color(context, "background"),
            child: LinearProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }
      },
    );
  }

  // Prepare things before we can start to present the map.
  Future<bool> _prepareMap() async {
    Logger.cyan("DashMap >> Preparing map...");
    await _loadMapStyle();
    Logger.cyan("DashMap >> Map prepared!");
    return true;
  }

  // Loads the _mapStyle configuration from assets based on brightness.
  Future<void> _loadMapStyle() async {
    // Loads the map style definition from asset file.
    String brightness = "light";
    if (Theme.of(context).colorScheme.brightness == Brightness.dark)
      brightness = "dark";
    String fileName = "assets/map-style-$brightness.txt";
    Logger.cyan("DashMap >> .. Loading map style... ");
    _mapStyle = await rootBundle.loadString(fileName);
    Logger.cyan("DashMap >> .. Map style $fileName loaded!");
  }

  // Centers the camera to the _currentPosition.
  void _centerCamera() async {
    final GoogleMapController controller = await _controller.future;
    Logger.cyan(
        "DashMap >> Centering camera at (${_cameraPosition.target.latitude},${_cameraPosition.target.longitude})");
    try {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    } catch (e) {
      Logger.red("DashMap >> Center camera failed: ${e.toString()}");
    }
  }

  // Builds the map control buttons.
  Widget _buildMapControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _toggleLegendButton(),
          _centerMapButton(),
        ],
      ),
    );
  }

  // Builds the legend toggle button.
  FloatingActionButton _toggleLegendButton() {
    return FloatingActionButton.extended(
      tooltip: _isLegendOn ? "Fechar legenda" : "Mostrar legenda",
      elevation: 4.0,
      icon: _isLegendOn ? Icon(VirusMapBRIcons.hide) : Icon(VirusMapBRIcons.show),
      label: Text(
        _isLegendOn ? "Fechar legenda" : "Mostrar legenda",
        style: Theme.of(context).textTheme.subtitle2.merge(
            TextStyle(color: VirusMapBRTheme.color(context, "primary", "white"))),
      ),
      backgroundColor: VirusMapBRTheme.color(context, "modal"),
      foregroundColor: VirusMapBRTheme.color(context, "primary", "white"),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
      ),
      onPressed: () {
        setState(() {
          if (_isLegendOn) {
            if (_legendController != null) {
              _legendController.close();
              _legendController = null;
            }
          } else {
            _legendController = _scaffoldKey.currentState
                .showBottomSheet<Null>((BuildContext context) {
              return _buildLegend();
            });
          }
          _isLegendOn = !_isLegendOn;
        });
      },
    );
  }

  // Builds the legend bottom sheet.
  Widget _buildLegend() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              color: VirusMapBRTheme.color(context, "modal"),
              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Entenda os casos no mapa",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        FloatingActionButton(
                          child: Icon(VirusMapBRIcons.exit),
                          foregroundColor: VirusMapBRTheme.color(context, "text3"),
                          elevation: 0,
                          mini: true,
                          backgroundColor:
                              VirusMapBRTheme.color(context, "highlight"),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_legendController != null) {
                                _legendController.close();
                                _legendController = null;
                                _isLegendOn = false;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(.1),
                      1: FlexColumnWidth(.9),
                      2: FlexColumnWidth(.1),
                      3: FlexColumnWidth(.9)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        legendDot("grey"),
                        Text("  Desconhecidos"),
                        legendDot("green"),
                        Text("  Recuperados"),
                      ]),
                      TableRow(children: [
                        legendDot("yellow"),
                        Text("  Suspeitos"),
                        legendDot("blue"),
                        Text("  Imunes"),
                      ]),
                      TableRow(children: [
                        legendDot("red"),
                        Text("  Confirmados"),
                        Text(""),
                        Text(""),
                      ])
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget legendDot(String key) {
    String brightness;
    if (Theme.of(context).brightness == Brightness.light) {
      brightness = "light";
    } else {
      brightness = "dark";
    }
    return Container(
      height: 24.0,
      width: 32.0,
      child: Image.asset("assets/$brightness-marker-$key.png"),
    );
  }

  // Builds the Center Map Button.
  Widget _centerMapButton() {
    return GestureDetector(
      onDoubleTap: () {
        Logger.yellow("DashMap >> Centering camera and adjusting zoom...");
        _followPosition = true;
        _cameraPosition = CameraPosition(
            target: _updatesProvider.currentPosition,
            zoom: GeoCalculator.kmToZoom(context, 0.5));
        _centerCamera();
      },
      child: FloatingActionButton(
        tooltip: 'Centralizar mapa',
        elevation: 4.0,
        child: Icon(VirusMapBRIcons.center_location),
        onPressed: () async {
          Logger.yellow("DashMap >> Centering camera...");
          _followPosition = true;
          _cameraPosition = CameraPosition(
              target: _updatesProvider.currentPosition,
              zoom: _cameraPosition.zoom);
          _centerCamera();
        },
      ),
    );
  }

  // Loads the map style when the map is created.
  void _handleMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    controller.setMapStyle(_mapStyle);
    Logger.yellow("DashMap >> Map created!");
  }

  // Handle camera movements.
  // This happens while the camera is moving (lots of calls).
  // Avoid expensise computation here.
  void _handleCameraMove(CameraPosition position) {
    _cameraPosition = position;
  }

  // Handle camera stops.
  // This happens after the camera movement finishes.
  void _handleCameraIdle() {
    Logger.cyan(
        "DashMap >> Camera moved to (${_cameraPosition.target.latitude},${_cameraPosition.target.longitude},${_cameraPosition.zoom}z)");
    _layersProvider.setCameraPosition(_cameraPosition);
  }

  // Cancels the existing streams subscriptions.
  @override
  void dispose() {
    Logger.green("DashMap >> Disposing...");
    _updatesProvider.removeListener(() {});
    _layersProvider.stop();
    super.dispose();
  }
}

class MyPanGestureRecognizer extends PanGestureRecognizer {
  Function _test;
  MyPanGestureRecognizer(this._test);
  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(disposition);
    this._test();
  }
}
