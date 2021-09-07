import 'package:flutter/material.dart';

class GradientColors {
  List<Color> setColorsSalt() {
    final List<Color> color = <Color>[];
    color.add(Colors.blue[50]);
    color.add(Colors.blue[200]);
    color.add(Colors.blue[300]);

    color.add(Colors.blue);
    return color;
  }

  List<Color> setColorsEC() {
    final List<Color> color = <Color>[];
    color.add(Colors.green[50]);
    color.add(Colors.green[200]);
    color.add(Colors.green[300]);

    color.add(Colors.green);
    return color;
  }

  List<Color> setColorsTemp() {
    final List<Color> color = <Color>[];
    color.add(Colors.orange[50]);
    color.add(Colors.orange[200]);
    color.add(Colors.orange[300]);

    color.add(Colors.orange);
    return color;
  }

  List<double> setStops() {
    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    stops.add(1.5);
    return stops;
  }
}
