import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Providers information about location permissions and location service status.

class LocationPermissionsProvider extends ChangeNotifier {
  PermissionStatus _permissionStatus;
  PermissionStatus _alwaysPermissionStatus;
  PermissionStatus _whenInUsePermissionStatus;
  ServiceStatus _serviceStatus;

  // Getters and Setters
  bool get permissionsAreFine =>
      (_permissionStatus == PermissionStatus.granted);
  bool get serviceIsFine => (_serviceStatus == ServiceStatus.enabled);
  bool get everythingIsFine => (serviceIsFine && permissionsAreFine);

  // Constructor
  LocationPermissionsProvider() {
    Logger.magenta("LocationPermissionsProvider >> Instance created!");
    _subscribeForServiceStatusChanges();
  }

  void _subscribeForServiceStatusChanges() {
    if (Platform.isAndroid) {
      Logger.magenta(
          "LocationPermissionsProvider >> .. subscribing for service status changes...!");
      final Stream<ServiceStatus> locationServiceStatusStream =
          LocationPermissions().serviceStatus;
      locationServiceStatusStream.listen((serviceStatus) {
        Logger.magenta(
            "LocationPermissionsProvider !! Service status changed to: $serviceStatus");
        var oldValue = everythingIsFine;
        _serviceStatus = serviceStatus;
        _log(minimal: true);
        _act(oldValue, everythingIsFine, true);
      });
    } else {
      Logger.magenta(
          "LocationPermissionsProvider >> Ignoring, we are running on iOS.");
    }
  }

  // Manually checks the permissions.
  void checkPermissions([bool notify = true]) async {
    await _checkPermissions(notify);
  }

  // Manually requests the permissions.
  void requestPermissions() async {
    Logger.magenta("LocationPermissionsProvider >> Requesting permissions...");
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(
            permissionLevel: LocationPermissionLevel.locationAlways);
    Logger.magenta(
        "LocationPermissionsProvider >> .. result: ${permissionRequestResult.toString()}");
    await _checkPermissions(false);
  }

  // Checks and updates the location services permission and availability.
  Future<void> _checkPermissions([bool notify = true]) async {
    var oldValue = everythingIsFine;
    Logger.magenta("LocationPermissionsProvider >> Checking permissions...");
    _permissionStatus = await LocationPermissions().checkPermissionStatus();
    _alwaysPermissionStatus = await LocationPermissions()
        .checkPermissionStatus(level: LocationPermissionLevel.locationAlways);
    _whenInUsePermissionStatus = await LocationPermissions()
        .checkPermissionStatus(
            level: LocationPermissionLevel.locationWhenInUse);
    _serviceStatus = await LocationPermissions().checkServiceStatus();
    _log(minimal: true);
    _act(oldValue, everythingIsFine, notify);
  }

  void _act(bool oldValue, bool newValue, bool notify) {
    if (oldValue != newValue) {
      Logger.magenta("LocationPermissionsProvider >> .. Things changed!");
      if (notify) {
        Logger.magenta(
            "LocationPermissionsProvider >> .... Notifying listners...");
        notifyListeners();
      } else {
        Logger.magenta("LocationPermissionsProvider >> .... Remaining silent.");
      }
    }
  }

  // Logs the provider status.
  void _log({bool minimal = false}) {
    if (!minimal)
      Logger.magenta("LocationPermissionsProvider >> Provider Status:");
    Logger.magenta(
        "LocationPermissionsProvider >> .. everythingIsFine    : ${everythingIsFine.toString()}");
    if (minimal) return;
    Logger.magenta(
        "LocationPermissionsProvider >> .. permissionsAreFine  : ${permissionsAreFine.toString()}");
    Logger.magenta(
        "LocationPermissionsProvider >> .. serviceIsFine       : ${serviceIsFine.toString()}");
    Logger.magenta(
        "LocationPermissionsProvider >> .. permission          : ${_permissionStatus.toString()}");
    Logger.magenta(
        "LocationPermissionsProvider >> .. alwaysPermission    : ${_alwaysPermissionStatus.toString()}");
    Logger.magenta(
        "LocationPermissionsProvider >> .. whenInUsePermission : ${_whenInUsePermissionStatus.toString()}");
    Logger.magenta(
        "LocationPermissionsProvider >> .. service             : ${_serviceStatus.toString()}");
  }
}
