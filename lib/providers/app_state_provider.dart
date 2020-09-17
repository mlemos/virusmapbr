
import 'package:flutter/widgets.dart';

class AppStateProvider extends ChangeNotifier {

  AppLifecycleState _state;
  AppLifecycleState get state => _state;

  void setState(AppLifecycleState newState) {
    _state = newState;
    notifyListeners();
  }
}