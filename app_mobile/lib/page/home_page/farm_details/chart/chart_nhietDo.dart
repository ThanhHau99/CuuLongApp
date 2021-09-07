import 'package:app_mobile/gradientColors/gradient_colors.dart';
import 'package:app_mobile/models/dataRealTime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartTemp extends StatefulWidget {
  final List<DataRealtime> dataLog;

  const ChartTemp({Key key, this.dataLog}) : super(key: key);
  @override
  _ChartTempState createState() => _ChartTempState(dataLog);
}

class _ChartTempState extends State<ChartTemp> {
  final List<DataRealtime> dataLog;

  TrackballBehavior _trackballBehavior;
  var temp;
  _ChartTempState(this.dataLog);
  LinearGradient _gradientColors;
  GradientColors _gradient = new GradientColors();

  void initState() {
    super.initState();

    _trackballBehavior = TrackballBehavior(
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        return Container(
            height: 50,
            width: 160,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 8, 22, 0.75),
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Row(children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                    '${DateFormat('dd-MM').add_jm().format(trackballDetails.point.x)}: ${(trackballDetails.point.y).toStringAsFixed(2)} °C',
                    style: TextStyle(
                        fontSize: 13, color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ]));
      },
    );

    _gradientColors = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: _gradient.setColorsTemp(),
        stops: _gradient.setStops());
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: "Nhiệt độ",
          textStyle: TextStyle(color: Colors.orangeAccent, fontSize: 20)),
      legend: Legend(isVisible: true),
      trackballBehavior: _trackballBehavior,
      primaryXAxis: DateTimeAxis(
          maximumLabels: 10,
          dateFormat: DateFormat('dd-MM').add_jm(),
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        // interval: 0.3, // khoang cach
        maximum: 50,
        labelFormat: '{value} °C',
      ),
      series: <ChartSeries<DataRealtime, dynamic>>[
        SplineAreaSeries<DataRealtime, dynamic>(
            name: "Nhiệt độ",
            dataSource: dataLog,
            xValueMapper: (DataRealtime data, _) => data.ts,
            yValueMapper: (DataRealtime data, _) => data.waterT,
            //dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            gradient: _gradientColors),
      ],
    );
  }
}
