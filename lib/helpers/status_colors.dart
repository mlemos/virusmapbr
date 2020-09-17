import 'package:flutter/material.dart';
import 'package:virusmapbr/themes/themes.dart';

class StatusColors {

    static Color color(BuildContext context, String covidHealthStatus) {
    switch (covidHealthStatus) {
      case "unknown":
        return VirusMapBRTheme.color(context, "text3");
      case "suspect":
        return VirusMapBRTheme.color(context, "alert");
      case "confirmed":
        return VirusMapBRTheme.color(context, "error");
      case "recovered":
        return VirusMapBRTheme.color(context, "success");
      case "immune":
        return VirusMapBRTheme.color(context, "blue");
      default:
        return VirusMapBRTheme.color(context, "text1");
    }
  }
}