import 'package:app_mobile/gradientColors/gradient_colors.dart';
import 'package:app_mobile/models/dataRealTime.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSalt extends StatefulWidget {
  final List<DataRealtime> dataLog;

  const ChartSalt({Key key, this.dataLog}) : super(key: key);
  @override
  _ChartSaltState createState() => _ChartSaltState(dataLog);
}

class _ChartSaltState extends State<ChartSalt> {
  final List<DataRealtime> dataLog;

  TrackballBehavior _trackballBehavior;
  ZoomPanBehavior _zoomPanBehavior;
  LinearGradient _gradientColors;
  GradientColors _gradient = new GradientColors();

  var temp;

  _ChartSaltState(this.dataLog);

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
                    '${DateFormat('dd-MM').add_jm().format(trackballDetails.point.x)}: ${(trackballDetails.point.y).toStringAsFixed(2)} ppt',
                    style: TextStyle(
                        fontSize: 13, color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ]));
      },
    );

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );

    _gradientColors = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: _gradient.setColorsSalt(),
        stops: _gradient.setStops());
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: "Độ mặn",
          textStyle: TextStyle(color: Colors.blueAccent, fontSize: 20)),
      legend: Legend(isVisible: true),
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: DateTimeAxis(
          //maximumLabels: 10,
          dateFormat: DateFormat('dd-MM').add_jm(),
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        //interval: 0.05, // khoang cach
        //maximum: 2,
        labelFormat: '{value} ppt',
      ),
      series: <ChartSeries<DataRealtime, dynamic>>[
        SplineAreaSeries<DataRealtime, dynamic>(
            name: "Độ măn",
            dataSource: dataLog,
            xValueMapper: (DataRealtime data, _) => data.ts,
            yValueMapper: (DataRealtime data, _) => data.waterSalt,
            //dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            //color: Colors.blueAccent,
            gradient: _gradientColors),
      ],
    );
  }
}
