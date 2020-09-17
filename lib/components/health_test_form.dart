import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/select_date.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthTestForm extends StatefulWidget {
  @override
  _HealthTestFormState createState() => _HealthTestFormState();
}

class _HealthTestFormState extends State<HealthTestForm> {
  final TextEditingController _testDateController = new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  HealthDataProvider _healthDataProvider;

  @override
  Widget build(BuildContext context) {
    _healthDataProvider = Provider.of<HealthDataProvider>(context);

    if (_healthDataProvider.healthData.covidTestDate != null) {
      _testDateController.value = TextEditingValue(
          text: _dateFormat.format(_healthDataProvider.healthData.covidTestDate));
    } else {
      _testDateController.value = TextEditingValue(text: "");
    }

    return Container(
      child: Column(
        children: [
          _buildCovidTested(context),
          if (_healthDataProvider.healthData.covidTestStatus ?? false)
            _buildCovidTestDate(context),
        ],
      ),
    );
  } 

  Widget _buildCovidTested(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Teste para COVID-19",
              style: Theme.of(context).textTheme.headline3),
          SizedBox(height: 16.0),
          Text("Você foi testado para COVID-19?",
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
                        groupValue: _healthDataProvider.healthData.covidTestStatus,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidTestStatus = value;
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
                        groupValue: _healthDataProvider.healthData.covidTestStatus,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidTestStatus = value;
                          _healthDataProvider.hasResult = false;
                          _healthDataProvider.healthData.covidTestDate = null;
                          _healthDataProvider.healthData.covidTestResult = null;
                          _healthDataProvider.healthData.covidTestResultDate = null;
                          _healthDataProvider.healthData.covidRecovered = null;
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

  Widget _buildCovidTestDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual foi a data da coleta do teste?",
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
                  _healthDataProvider.healthData.covidTestDate, _testDateController);
              Logger.cyan("selectedData = $selectedDate");
              if (selectedDate != null) {
                _healthDataProvider.healthData.covidTestDate = selectedDate;
                await _healthDataProvider.save(persist: false);
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _testDateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "data da coleta",
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
