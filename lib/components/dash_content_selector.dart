import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/screens/dash_config.dart';
import 'package:virusmapbr/screens/dash_health.dart';
import 'package:virusmapbr/screens/dash_help.dart';
import 'package:virusmapbr/screens/dash_map.dart';
import 'package:virusmapbr/screens/dashboard.dart';
import 'package:virusmapbr/services/firebase_analytics.dart';

class DashContentSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    switch (navigationProvider.currentIndex) {
      case 0:
        _logNavigation("dashboard");
        return Dashboard();
        break;
      case 1:
        _logNavigation("dash_health");
        return DashHealth();
        break;
      case 2:
        _logNavigation("dash_map");
        return DashMap();
        break;
      case 3:
        _logNavigation("dash_help");
        return DashHelp();
        break;
      case 4:
        _logNavigation("dash_config");
        return DashConfig();
        break;
      default:
        _logNavigation("dash_unknown");
        return Text("Erro: Você não deveria estar aqui.");
    }
  }

  void _logNavigation(String destiny) {
    Logger.white("DashContentSelector >> Selcted: $destiny");
    firebaseLogEvent(destiny);
  }
}
