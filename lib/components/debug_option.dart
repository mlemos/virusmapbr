import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/providers/updates_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class DebugOption extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<DebugOption> {
  bool _showDebug = false;
  UpdatesProvider _updatesProvider;
  HealthDataProvider  _healthDataProvider;

  @override
  Widget build(BuildContext context) {
    _updatesProvider = Provider.of<UpdatesProvider>(context);
    _healthDataProvider = Provider.of<HealthDataProvider>(context);
    return Column(
      children: [
        FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              _showDebug = !_showDebug;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: VirusMapBRTheme.color(context, "success").withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    VirusMapBRIcons.bug,
                    color: VirusMapBRTheme.color(context, "success"),
                    size: 24.0,
                  ),
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Text("Informações para debug",
                    style: Theme.of(context).textTheme.subtitle1.merge(
                        TextStyle(
                            color: VirusMapBRTheme.color(context, "success")))),
              ),
              Container(
                child: Icon(
                  _showDebug ? VirusMapBRIcons.arrow_down : VirusMapBRIcons.arrow_right,
                  color: VirusMapBRTheme.color(context, "success"),
                  size: 24.0,
                ),
              )
            ],
          ),
        ),
        _showDebug ? _buildDebugInfo() : SizedBox(height: 1.0),
      ],
    );
  }

  Widget _buildDebugInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      child: Column(
        children: [
          _buildDebugSession(),
          Divider(
            color: Colors.grey,
          ),
          _buildDebugPosition(),
          Divider(
            color: Colors.grey,
          ),
          _buildDebugHealth(),
        ],
      ),
    );
  }

  // Prints the session debug info.
  Widget _buildDebugSession() {
    SessionProvider _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("uid:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            _sessionProvider.session.uid != null
                ? _sessionProvider.session.uid.substring(0, 10) +
                    "..." +
                    _sessionProvider.session.uid
                        .substring(_sessionProvider.session.uid.length - 10)
                : "",
            overflow: TextOverflow.fade,
            softWrap: false,
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("displayName:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_sessionProvider.session.displayName ?? "")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("email:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_sessionProvider.session.email ?? "")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("phoneNumber:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_sessionProvider.session.phoneNumber ?? "")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("userHash:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            _sessionProvider.session.userHash != null
                ? _sessionProvider.session.userHash.substring(0, 10) +
                    "..." +
                    _sessionProvider.session.userHash
                        .substring(_sessionProvider.session.userHash.length - 10)
                : "",
            overflow: TextOverflow.fade,
            softWrap: false,
          )
        ]),
      ],
    );
  }

  // Prints the health debug info.
  Widget _buildDebugHealth() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidHealthStatus:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidHealthStatus.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidHasSymptoms:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidHasSymptoms.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidHasCriticalSymptoms:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidHasCriticalSymptoms.toString() ??
                "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidSymptoms:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidSymptoms.values.map((i) => ((i) ? "x" : "-")).join())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidTestStatus:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData. covidTestStatus.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidTestDate:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidTestDate.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidTestResultStatus:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidTestResult.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidTestResultDate:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidTestResultDate.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidRecovered:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidRecovered.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidRecoveredDate:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidRecoveredDate.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidImmune:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidImmune.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("covidImmuneDate:  ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.covidImmuneDate.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("updatedAt:  ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.updatedAt.toString() ?? "")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("desviralize:  ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_healthDataProvider.healthData.shareWithDesviralize.toString() ?? "")
          ],
        ),
      ],
    );
  }

  // Prints the location debug info.
  Widget _buildDebugPosition() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("latitude:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_updatesProvider.currentPosition != null
              ? _updatesProvider.currentPosition.latitude.toString()
              : "")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("longitude:  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_updatesProvider.currentPosition != null
              ? _updatesProvider.currentPosition.longitude.toString()
              : "")
        ]),
      ],
    );
  }
}
