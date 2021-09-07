import 'package:cloud_firestore/cloud_firestore.dart';

class ChartData {
  ChartData({this.myTimestamp, this.waterSalt, this.waterT});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : myTimestamp = dataMap['myTimestamp'],
        waterSalt = dataMap['waterSalt'],
        waterT = dataMap['waterT'];
  final Timestamp myTimestamp;
  final num waterSalt;
  final num waterT;
}
