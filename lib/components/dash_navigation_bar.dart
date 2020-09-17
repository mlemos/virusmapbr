import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/helpers/status_colors.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/providers/location_permissions_provider.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class DashNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationProvider =
        Provider.of<NavigationProvider>(context);
    final permissionsProvider =
        Provider.of<LocationPermissionsProvider>(context);
    final healthDataProvider = Provider.of<HealthDataProvider>(context);

    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(50),
            blurRadius: 10,
            offset: Offset(0,-10),
          )
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: navigationProvider.currentIndex,
        backgroundColor: Theme.of(context).backgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: VirusMapBRTheme.color(context, "text4"),
        items: [
          BottomNavigationBarItem(
            icon: Icon(VirusMapBRIcons.menu_outline, size: 24.0),
            activeIcon: Icon(VirusMapBRIcons.menu_filled, size: 24.0),
            title: Text("Início"),
          ),
          _navItemWithStatus(
            context,
            "Dados de Saúde",
            VirusMapBRIcons.health_outline,
            VirusMapBRIcons.health_filled,
            _healthStatusColor(context, healthDataProvider),
          ),
          BottomNavigationBarItem(
            icon: Icon(VirusMapBRIcons.map_outline, size: 24.0),
            activeIcon: Icon(VirusMapBRIcons.map_filled, size: 24),
            title: Text("Mapa"),
          ),
          BottomNavigationBarItem(
            icon: Icon(VirusMapBRIcons.question_outline, size: 24),
            activeIcon: Icon(VirusMapBRIcons.question_filled, size: 24),
            title: Text("Ajuda"),
          ),
          _navItemWithStatus(
            context,
            "Configurações",
            OMIcons.settings,
            Icons.settings,
            _settingsColor(permissionsProvider),
          ),
        ],
        onTap: (index) {
          permissionsProvider.checkPermissions();
          navigationProvider.setTab(index);
        },
      ),
    );
  }

  Color _settingsColor(LocationPermissionsProvider permissionsProvider) {
    if (permissionsProvider.everythingIsFine) {
      return null;
    } else {
      return Colors.red;
    }
  }

  Color _healthStatusColor(
      BuildContext context, HealthDataProvider healthDataProvider) {
    Logger.white(
        "DashNavigationBar >> healthStatus is: ${healthDataProvider.healthData.covidHealthStatus}");
    return StatusColors.color(
        context, healthDataProvider.healthData.covidHealthStatus);
  }

  BottomNavigationBarItem _navItemWithStatus(BuildContext context, String label,
      IconData icon, IconData activeIcon, Color statusColor) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(icon, size: 24),
          if (statusColor != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
        ],
      ),
      activeIcon: Stack(
        children: [
          Icon(activeIcon, size: 24),
          if (statusColor != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
        ],
      ),
      title: Text(label),
    );
  }
}
