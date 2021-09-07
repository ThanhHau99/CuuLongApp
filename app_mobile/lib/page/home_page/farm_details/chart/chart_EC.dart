import 'package:app_mobile/gradientColors/gradient_colors.dart';
import 'package:app_mobile/models/dataRealTime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartEC extends StatefulWidget {
  final List<DataRealtime> dataLog;

  const ChartEC({Key key, this.dataLog}) : super(key: key);
  @override
  _ChartECState createState() => _ChartECState(dataLog);
}

class _ChartECState extends State<ChartEC> {
  final List<DataRealtime> dataLog;

  TrackballBehavior _trackballBehavior;

  _ChartECState(this.dataLog);
  LinearGradient _gradientColors;
  GradientColors _gradient = new GradientColors();

  void initState() {
    super.initState();

    _trackballBehavior = TrackballBehavior(
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        return Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 8, 22, 0.75),
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Row(children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                    '${DateFormat('dd-MM').add_jm().format(trackballDetails.point.x)}:\n${(trackballDetails.point.y).toStringAsFixed(2)} mS/cm',
                    style: TextStyle(
                        fontSize: 13, color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ]));
      },
    );

    _gradientColors = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: _gradient.setColorsEC(),
        stops: _gradient.setStops());
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: "EC",
          textStyle: TextStyle(color: Colors.greenAccent, fontSize: 20)),
      legend: Legend(isVisible: true),
      trackballBehavior: _trackballBehavior,
      primaryXAxis: DateTimeAxis(
          maximumLabels: 10,
          dateFormat: DateFormat('dd-MM').add_jm(),
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        // interval: 0.3, // khoang cach
        maximum: 5000,
        labelFormat: '{value} mS/cm',
      ),
      series: <ChartSeries<DataRealtime, dynamic>>[
        SplineAreaSeries<DataRealtime, dynamic>(
            name: "EC",
            dataSource: dataLog,
            xValueMapper: (DataRealtime data, _) => data.ts,
            yValueMapper: (DataRealtime data, _) => data.waterEC,
            //dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            gradient: _gradientColors),
      ],
    );
  }
}
