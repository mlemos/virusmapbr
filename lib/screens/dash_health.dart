import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/health_birthdate_form.dart';
import 'package:virusmapbr/components/health_immune_form.dart';
import 'package:virusmapbr/components/health_instructions.dart';
import 'package:virusmapbr/components/health_recovered_form.dart';
import 'package:virusmapbr/components/health_symptoms_form.dart';
import 'package:virusmapbr/components/health_test_form.dart';
import 'package:virusmapbr/components/health_test_result_form.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/providers/updates_provider.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/helpers/logger.dart';

class DashHealth extends StatefulWidget {
  @override
  _DashHealthState createState() => _DashHealthState();
}

class _DashHealthState extends State<DashHealth> {
  HealthDataProvider _healthDataProvider;
  UpdatesProvider _updatesProvider;

  @override
  Widget build(BuildContext context) {
    _updatesProvider = Provider.of<UpdatesProvider>(context, listen: false);
    _healthDataProvider = Provider.of<HealthDataProvider>(context);
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "background"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return Container(
      child: instructionsOrForm(),
    );
  }

  @override
  void dispose() async {
    Logger.green("DashHealth >> Disposing...");
    _save();
    super.dispose();
  }

  Future<void> _save() async {
    await _healthDataProvider.save();
    _updatesProvider.updateNow();
  }

  Widget instructionsOrForm() {
    if (_healthDataProvider.firstTime) {
      return HealthInstructions();
    } else {
      return ListView(
        children: [
          buildHeader(),
          buildNotice(),
          HealthBirthdateForm(),
          HealthTestForm(),
          HealthTestResultForm(),
          HealthRecoveredForm(),
          HealthImmuneForm(),
          HealthSymptomsForm(),
          buildSaveButton(),
        ],
      );
    }
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Atualize seus dados de saúde",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      "Siga atentamente as instruções para preencher o formulário.",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              _buildHelpButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return Container(
      height: 32.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: VirusMapBRTheme.color(context, "highlight"),
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.all(0),
          color: VirusMapBRTheme.color(context, "text3"),
          icon: Icon(VirusMapBRIcons.question_outline,),
          onPressed: () {
            _healthDataProvider.forceInstructions();
          },
        ),
      ),
    );
  }


  Widget buildNotice() {
    Color color;
    String notice;
    IconData icon;
    if (_healthDataProvider.healthData.updatedAt == null) {
      color = VirusMapBRTheme.color(context, "alert");
      icon = VirusMapBRIcons.alert_circular;
      notice = "Você ainda não respondeu ao questionário.";
    } else {
      color = VirusMapBRTheme.color(context, "primary");
      icon = VirusMapBRIcons.alert_circular;
      var updatedAt = Jiffy(_healthDataProvider.healthData.updatedAt)
          .format("d/MMM/y [às] H:mm[h]");
      notice = "Última atualização em ${updatedAt.toString()}.";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.1),
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 12.0),
            Expanded(
                          child: Text(
                notice,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(color: color),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Text(
                  "Salvar",
                  style: Theme.of(context).textTheme.headline3.merge(
                      TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                ),
                onPressed: () async {
                  await _save();
                  //setState(() {});

                  Flushbar(
                    messageText: Row(
                      children: [
                        Container(
                          height: 48.0,
                          width: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: VirusMapBRTheme.color(context, "white")
                                .withOpacity(0.4),
                          ),
                          child: Center(
                              child:
                                  Text("💙", style: TextStyle(fontSize: 24.0))),
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                            child: Text(
                          "Obrigado! Suas informações são importantes para combater o Coronavírus.",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(TextStyle(color: Colors.white)),
                        ))
                      ],
                    ),
                    backgroundColor: VirusMapBRTheme.color(context, "primary"),
                    flushbarPosition: FlushbarPosition.TOP,
                    flushbarStyle: FlushbarStyle.FLOATING,
                    margin: const EdgeInsets.all(24.0),
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    borderRadius: 12.0,
                    duration: Duration(seconds: 3),
                  )..show(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
