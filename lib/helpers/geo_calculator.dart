import 'dart:math';
import 'package:flutter/material.dart';

class GeoCalculator {

  // Converts meters to zoom level
  static double kmToZoom(BuildContext context, double kilometers) {
    double equatorLength = 40075; // in kilometers
    double widthInPixels = MediaQuery.of(context).size.width;
    double k = (equatorLength * widthInPixels) / (256 * kilometers);
    double zoomLevel = log(k) / log(2);
    return zoomLevel;
  }

  // Converts zoom level to kilometers
  static double zoomToKm(BuildContext context, double zoomLevel) {
    double equatorLength = 40075; // in kilometers
    double widthInPixels = max(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    double kilometers =
        (equatorLength * widthInPixels) / (256 * pow(2, zoomLevel));
    return kilometers;
  }

}
