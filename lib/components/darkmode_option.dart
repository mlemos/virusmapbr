import 'package:flutter/material.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';

class DarkModeOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            VirusMapBRIcons.dark_mode,
            color: VirusMapBRTheme.color(context, "text1"),
            size: 24.0,
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Text("Habilitar modo escuro",
              style: Theme.of(context).textTheme.subtitle1.merge(
                  TextStyle(color: VirusMapBRTheme.color(context, "text1")))),
        ),
        Container(
          child: Switch(
            value: false,
            onChanged: (bool) {},
          ),
        )
      ],
    );
  }
}
