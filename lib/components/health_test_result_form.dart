import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/select_date.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthTestResultForm extends StatefulWidget {
  @override
  _HealthTestResultFormState createState() => _HealthTestResultFormState();
}

class _HealthTestResultFormState extends State<HealthTestResultForm> {
  final TextEditingController _testResultDateController =
      new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  HealthDataProvider _healthDataProvider;
  bool _hasResult;

  @override
  Widget build(BuildContext context) {
    _healthDataProvider = Provider.of<HealthDataProvider>(context);
    _hasResult = _healthDataProvider.hasResult ||
        (_healthDataProvider.healthData.covidTestResult != null);

    if (_healthDataProvider.healthData.covidTestResultDate != null) {
      _testResultDateController.value = TextEditingValue(
          text: _dateFormat
              .format(_healthDataProvider.healthData.covidTestResultDate));
    } else {
      _testResultDateController.value = TextEditingValue(text: "");
    }

    return Container(
      child: Column(
        children: [
          if (_healthDataProvider.healthData.covidTestStatus ?? false)
            _buildCovidTestResult(context),
          if ((_healthDataProvider.healthData.covidTestStatus ?? false) &&
              _hasResult)
            _buildCovidTestResultDetails(context),
        ],
      ),
    );
  }

  Widget _buildCovidTestResult(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.0),
          Text("Já tem o resultado do teste?",
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
                        groupValue: _hasResult,
                        onChanged: (bool value) async {
                          _healthDataProvider.hasResult = value;
                          await _healthDataProvider.save(persist: false);
                          Logger.red("Sim!");
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
                        groupValue: _hasResult,
                        onChanged: (bool value) async {
                          _healthDataProvider.hasResult = value;
                          _healthDataProvider.healthData.covidTestResult = null;
                          _healthDataProvider.healthData.covidTestResultDate =
                              null;
                          _healthDataProvider.healthData.covidRecovered = null;
                          _healthDataProvider.healthData.covidRecoveredDate =
                              null;
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

  Widget _buildCovidTestResultDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual foi o resultado do teste?",
            style: Theme.of(context).textTheme.subtitle1.merge(
                  TextStyle(
                    color: VirusMapBRTheme.color(context, "text2"),
                  ),
                ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: VirusMapBRTheme.color(context, "text4"),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue:
                            _healthDataProvider.healthData.covidTestResult,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidTestResult =
                              value;
                          await _healthDataProvider.save(persist: false);
                        },
                      ),
                      Text(
                        "Positivo",
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
                        groupValue:
                            _healthDataProvider.healthData.covidTestResult,
                        onChanged: (value) async {
                          _healthDataProvider.healthData.covidTestResult =
                              value;
                          _healthDataProvider.healthData.covidRecovered = null;
                          _healthDataProvider.healthData.covidRecoveredDate =
                              null;
                          _healthDataProvider.healthData.covidImmune = null;
                          _healthDataProvider.healthData.covidImmuneDate = null;
                          await _healthDataProvider.save(persist: false);
                        },
                      ),
                      Text(
                        "Negativo",
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
          SizedBox(height: 32.0),
          Text(
            "Qual foi a data do resultado do teste?",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .merge(TextStyle(color: VirusMapBRTheme.color(context, "text2"))),
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              DateTime selectedDate = await SelectDate.picker(
                  context,
                  _healthDataProvider.healthData.covidTestResultDate,
                  _testResultDateController,
                  _healthDataProvider.healthData.covidTestDate);
              if (selectedDate != null) {
                _healthDataProvider.healthData.covidTestResultDate =
                    selectedDate;
                await _healthDataProvider.save(persist: false);
              }
              Logger.info("");
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _testResultDateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "data do resultado",
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
