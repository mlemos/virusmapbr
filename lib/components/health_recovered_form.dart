import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/select_date.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthRecoveredForm extends StatefulWidget {
  @override
  _HealthRecoveredFormState createState() => _HealthRecoveredFormState();
}

class _HealthRecoveredFormState extends State<HealthRecoveredForm> {
  final TextEditingController _dateController = new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  HealthDataProvider _healthDataProvider;

  @override
  Widget build(BuildContext context) {
    _healthDataProvider = Provider.of<HealthDataProvider>(context);

    if (_healthDataProvider.healthData.covidRecoveredDate != null) {
      _dateController.value = TextEditingValue(
          text: _dateFormat.format(_healthDataProvider.healthData.covidRecoveredDate));
    } else {
      _dateController.value = TextEditingValue(text: "");
    }

    return Container(
      child: Column(
        children: [
          if (_healthDataProvider.healthData.covidTestResult ?? false) _buildCovidRecovered(context),
          if ((_healthDataProvider.healthData.covidTestResult ?? false) && (_healthDataProvider.healthData.covidRecovered ?? false))
            _buildCovidRecoveredDate(context),
        ],
      ),
    );
  } 

  Widget _buildCovidRecovered(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recuperação do COVID-19",
              style: Theme.of(context).textTheme.headline3),
          SizedBox(height: 16.0),
          Text("Você já se recuperou do COVID-19?",
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: VirusMapBRTheme.color(context, "text4")),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: _healthDataProvider.healthData.covidRecovered,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidRecovered = value;
                          await _healthDataProvider.save(persist: false);
                        },
                      ),
                      Text(
                        "Sim",
                        style: Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                color: VirusMapBRTheme.color(context, "text3"),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: VirusMapBRTheme.color(context, "text4")),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: _healthDataProvider.healthData.covidRecovered,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidRecovered = value;
                          _healthDataProvider.healthData.covidRecoveredDate = null;
                          _healthDataProvider.healthData.covidImmune = null;
                          _healthDataProvider.healthData.covidImmuneDate = null;
                          await _healthDataProvider.save(persist: false);
                        },
                      ),
                      Text(
                        "Não",
                        style: Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                color: VirusMapBRTheme.color(context, "text3"),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCovidRecoveredDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual foi a data de sua recuperação?",
            style: Theme.of(context).textTheme.subtitle1.merge(
                  TextStyle(
                    color: VirusMapBRTheme.color(context, "text2"),
                  ),
                ),
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              DateTime selectedDate = await SelectDate.picker(context,
                  _healthDataProvider.healthData.covidRecoveredDate, _dateController);
              Logger.cyan("selectedData = $selectedDate");
              if (selectedDate != null) {
                _healthDataProvider.healthData.covidRecoveredDate = selectedDate;
                await _healthDataProvider.save(persist: false);
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "data da recuperação",
                  suffixIcon: Icon(
                    VirusMapBRIcons.calendar,
                    color: VirusMapBRTheme.color(context, "text4"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
