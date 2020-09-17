import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/models/health_data.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthSymptomsForm extends StatefulWidget {
  @override
  _HealthSymptomsFormState createState() => _HealthSymptomsFormState();
}

class _HealthSymptomsFormState extends State<HealthSymptomsForm> {
  HealthDataProvider _healthDataProvider;

  @override
  Widget build(BuildContext context) {
    _healthDataProvider = Provider.of<HealthDataProvider>(context);
    return Container(
      child: Column(
        children: [
          _buildSymptomsDetails(context),
        ],
      ),
    );
  }

  Widget _buildSymptomsDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sintomas", style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 16.0),
              Text(
                  "Você está, ou esteve, com algum sintoma nas últimas 48 horas?",
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 8.0),
            ],
          ),
        ),
        for (var symptom in HealthData.covidSymptomsDescriptions.keys)
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _healthDataProvider.healthData.covidSymptoms[symptom] ?? false,
            title: Text(
              HealthData.covidSymptomsDescriptions[symptom],
              style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(
                      color: VirusMapBRTheme.color(context, "text3"),
                    ),
                  ),
            ),
            onChanged: (bool value) async {
              _healthDataProvider.healthData.covidSymptoms[symptom] = value;
              await _healthDataProvider.save(persist: false);
            },
          ),
      SizedBox(height: 32.0),
      ],
    );
  }

  // Widget _buildHasSymptoms(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 32.0),
  //         Text("Sintomas", style: Theme.of(context).textTheme.headline4),
  //         SizedBox(height: 16.0),
  //         Text("Você está, ou esteve, com algum sintoma nas últimas 48 horas?",
  //             style: Theme.of(context).textTheme.subtitle2),
  //         SizedBox(height: 8.0),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 height: 48.0,
  //                 decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: VirusMapBRTheme.color(context, "text4")),
  //                   borderRadius: BorderRadius.circular(4.0),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Radio(
  //                       value: true,
  //                       groupValue: _hasSymptoms,
  //                       onChanged: (bool value) {
  //                         setState(() {
  //                           _hasSymptoms = value;
  //                         });
  //                       },
  //                     ),
  //                     Text(
  //                       "Sim",
  //                       style: Theme.of(context).textTheme.subtitle1.merge(
  //                             TextStyle(
  //                               color: VirusMapBRTheme.color(context, "text3"),
  //                             ),
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 8,
  //             ),
  //             Expanded(
  //               child: Container(
  //                 height: 48.0,
  //                 decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: VirusMapBRTheme.color(context, "text4")),
  //                   borderRadius: BorderRadius.circular(4.0),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Radio(
  //                       value: false,
  //                       groupValue: _hasSymptoms,
  //                       onChanged: (bool value) async {
  //                         _hasSymptoms = value;
  //                         widget.healthData.covidSymptoms.clear();
  //                         widget.onUpdateNeeded();
  //                       },
  //                     ),
  //                     Text(
  //                       "Não",
  //                       style: Theme.of(context).textTheme.subtitle1.merge(
  //                             TextStyle(
  //                               color: VirusMapBRTheme.color(context, "text3"),
  //                             ),
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
