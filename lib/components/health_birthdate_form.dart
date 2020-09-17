import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/select_date.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthBirthdateForm extends StatefulWidget {
  @override
  _HealthBirthdateFormState createState() => _HealthBirthdateFormState();
}

class _HealthBirthdateFormState extends State<HealthBirthdateForm> {
  final TextEditingController _birthdateController =
      new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  HealthDataProvider _healthDataProvider;

  @override
  Widget build(BuildContext context) {
    _healthDataProvider = Provider.of<HealthDataProvider>(context);
    if (_healthDataProvider.healthData.birthdate != null) {
      _birthdateController.value = TextEditingValue(
          text: _dateFormat.format(_healthDataProvider.healthData.birthdate));
    } else {
      _birthdateController.value = TextEditingValue(text: "");
    }

    return Container(
      child: Column(
        children: [
          _buildBirthdate(context),
        ],
      ),
    );
  }

  Widget _buildBirthdate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data de Nascimento",
              style: Theme.of(context).textTheme.headline3),
          SizedBox(height: 16.0),
          Text("Qual a data de seu nascimento?",
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              DateTime selectedDate = await SelectDate.picker(
                  context,
                  _healthDataProvider.healthData.birthdate,
                  _birthdateController,
                  DateTime(1900, 1, 1));
              Logger.cyan("selectedData = $selectedDate");
              if (selectedDate != null) {
                Logger.cyan("changing the date to: $selectedDate");
                _healthDataProvider.healthData.birthdate = selectedDate;
                await _healthDataProvider.save(persist: false);
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _birthdateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "data de nascimento",
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
