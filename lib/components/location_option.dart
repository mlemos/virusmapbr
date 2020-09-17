import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/my_alert_dialog.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/providers/location_permissions_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class LocationOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocationPermissionsProvider permissionsProvider =
        Provider.of<LocationPermissionsProvider>(context);
    return FlatButton(
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        await _showLocationPermissionsDialog(context, permissionsProvider);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  VirusMapBRIcons.place,
                  color: VirusMapBRTheme.color(context, "text1"),
                  size: 24.0,
                ),
              ),
              if (!permissionsProvider.everythingIsFine)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.red,
                  ),
                ),
              if (permissionsProvider.everythingIsFine)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.green,
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text("Compartilhar localização",
                style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "text1")))),
          ),
          Container(
            child: Icon(
              VirusMapBRIcons.arrow_right,
              color: VirusMapBRTheme.color(context, "text1"),
              size: 24.0,
            ),
          )
        ],
      ),
    );
  }

  Future _showLocationPermissionsDialog(BuildContext context, LocationPermissionsProvider permissionsProvider) async {
    if (!permissionsProvider.everythingIsFine) {
      // No location permission granted.
      // We can't work at all.
      // Please grant the permission.
      await showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog(
            title: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    VirusMapBRIcons.place,
                    color: VirusMapBRTheme.color(context, "text1"),
                    size: 24.0,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text("Acesso à Localização"),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Para o aplicativo funcionar corretamente, precisamos ter acesso à sua localização."),
                SizedBox(height: 16.0),
                Text("Por favor habilite o acesso à localização em:"),
                SizedBox(height: 16.0),
                Text(
                    "Informações do app > Permissões > Local > Permitir o tempo todo"),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("IR PARA CONFIGURAÇÕES"),
                onPressed: () async {
                  await LocationPermissions().openAppSettings();
                },
              ),
            ],
          );
        },
      );
    }

    if (!permissionsProvider.serviceIsFine) {
      // Location services not enabled.
      // We can't work at all.
      // Please turn it on.
      await showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog(
            title: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    VirusMapBRIcons.place,
                    color: VirusMapBRTheme.color(context, "text1"),
                    size: 24.0,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text("Localização Desligada"),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Para o aplicativo funcionar corretamente é preciso que o serviço de localização esteja ligado."),
                SizedBox(height: 16.0),
                Text(
                    "Por favor habilite o serviço de localização (GPS) de seu dispositivo"),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    if (permissionsProvider.permissionsAreFine) {
      await showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog(
            title: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    VirusMapBRIcons.place,
                    color: VirusMapBRTheme.color(context, "text1"),
                    size: 24.0,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text("Localização"),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Seu compartilhamento de localização está configurado corretamente."),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
