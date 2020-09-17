import 'package:flutter/material.dart';
import 'package:virusmapbr/helpers/logger.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  // Getters and Setters
  int get currentIndex => _currentIndex;

  // Constructor
  NavigationProvider() {
    Logger.magenta("NavigatorProvider >> Instance created!");
  }

  void setTab(int index, [bool notify = true]) {
    if (_currentIndex != index) {
      Logger.magenta(
          "NavigationProvider >> Tab changed from $_currentIndex to $index (changing).");
      Logger.magenta("NavigationProvider >> .. Notify is $notify.");
      _currentIndex = index;
      if (notify) {
        notifyListeners();
      }
    } else {
      Logger.magenta(
          "NavigationProvider >> Tab remains the same $_currentIndex (ignoring).");
    }
  }

  void reset() {
    _currentIndex = 0;
  }

  Map getStatus() {
    var status = {
      "currentIndex": _currentIndex,
    };
    return status;
  }

}
