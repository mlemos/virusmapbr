import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class DesviralizeOption extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  HealthDataProvider  _healthDataProvider = Provider.of<HealthDataProvider>(context);
    bool status = _healthDataProvider.healthData.shareWithDesviralize ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            VirusMapBRIcons.desviralize,
            color: VirusMapBRTheme.color(context, "text1"),
            size: 24.0,
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Text("Integrar com Desviralize",
              style: Theme.of(context).textTheme.subtitle1.merge(
                  TextStyle(color: VirusMapBRTheme.color(context, "text1")))),
        ),
        Container(
            child: Switch(
          value: status,
          onChanged: (bool) async {
            status = !status;
            _healthDataProvider.healthData.shareWithDesviralize = status;
            await _healthDataProvider.save(persist: true);
            Logger.yellow(
                "DesviralizeOption >> Status is: ${_healthDataProvider.healthData.shareWithDesviralize}");
          },
        ))
      ],
    );
  }
}
