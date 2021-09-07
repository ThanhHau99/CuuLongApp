import 'package:app_mobile/models/dataRealTime.dart';
import 'package:app_mobile/models/data_status.dart';
import 'package:app_mobile/page/home_page/farm_details/chart/chart_EC.dart';
import 'package:app_mobile/page/home_page/farm_details/chart/chart_nhietDo.dart';
import 'package:app_mobile/page/home_page/farm_details/chart/chart_salt.dart';
import 'package:app_mobile/share/app_images.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final DataStatus dataStatus;

  const Chart({Key key, this.dataStatus}) : super(key: key);

  @override
  _ChartState createState() => _ChartState(dataStatus);
}

class _ChartState extends State<Chart> {
  final DataStatus dataStatus;

  _ChartState(this.dataStatus);
  DatabaseReference referenceData = FirebaseDatabase.instance.reference();
  final List<DataRealtime> dataLog = [];

  String dropDownValue = "1 hour";
  var end = 1628356792;

  var temp;

  void initState() {
    super.initState();
    loadDataStatus(3600);
  }

  List<DataRealtime> loadDataStatus(int time) {
    referenceData
        .child("Devices")
        .child("log")
        .child(dataStatus.id.toString())
        .once()
        .then((DataSnapshot dataSnapShot) {
      dataLog.clear();

      var keys = dataSnapShot.value.keys;
      print(keys.length);
      for (String key in keys) {
        if (int.parse(key) <= end && int.parse(key) >= (end - time)) {
          var values = dataSnapShot.value;
          DataRealtime data = new DataRealtime(
            DateTime.fromMillisecondsSinceEpoch(values[key]['ts'] * 1000),
            values[key]['waterSalt'],
            values[key]['waterT'],
            values[key]['waterEC'],
            key,
          );

          dataLog.add(data);
        }
      }
      var temp;
      print(dataLog.length);
      for (int i = 0; i < dataLog.length - 1; i++) {
        for (int j = i + 1; j < dataLog.length; j++) {
          if (int.parse(dataLog[i].id) > int.parse(dataLog[j].id)) {
            temp = dataLog[i];
            dataLog[i] = dataLog[j];
            dataLog[j] = temp;
          }
        }
      }
      setState(() {
        //
      });

      // for (int i = 0; i < dataLog.length; i++) {
      //   DateTime c = DateTime.fromMillisecondsSinceEpoch(
      //       int.parse(dataLog[i].id) * 1000);
      //   print('$i : ${c.toString()}');
      // }
    });

    return dataLog;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Biểu đồ",
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Image.asset(
                    AppImages.iconWater,
                    height: 20,
                    width: 20,
                  ),
                  child: Text(
                    "Độ mặn",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  )),
              Tab(
                  child: Text(
                "EC",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              )),
              Tab(
                  icon: Image.asset(
                    AppImages.iconTemp,
                    height: 25,
                    width: 35,
                  ),
                  child: Text(
                    "Nhiệt độ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  )),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Column(
            children: [
              _buildDropDownButton(),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: dataLog.length == 0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : TabBarView(
                          children: [
                            ChartSalt(
                              dataLog: dataLog,
                            ),
                            ChartEC(dataLog: dataLog),
                            ChartTemp(dataLog: dataLog),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              //color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton(
            value: dropDownValue,
            underline: Container(
              color: Colors.grey[350],
              height: 2,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropDownValue = newValue;
                print(dropDownValue);
                change();
              });
            },
            items: <String>["1 hour", "1 day"]
                .map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  "$value",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void change() {
    if (dropDownValue.contains("hour")) {
      print("this is hour");
      int time = 3600;
      loadDataStatus(time);
    }
    if (dropDownValue.contains("day")) {
      print("this is day");
      int time = 86400;
      loadDataStatus(time);
    }
  }
}
