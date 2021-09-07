import 'dart:ffi';
import 'package:app_mobile/models/data_status.dart';
import 'package:app_mobile/page/home_page/farm_details/farmDetails_page.dart';
import 'package:app_mobile/page/home_page/home_page.dart';
import 'package:app_mobile/services/database.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:app_mobile/share/widget_card.dart';
import 'package:app_mobile/share/widget_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<DataStatus> dataList = [];
  FlutterLocalNotificationsPlugin localNotifications;

  @override
  Void initState() {
    super.initState();

    var androidInitialize = new AndroidInitializationSettings('logo');

    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);

    localNotifications =
        new FlutterLocalNotificationsPlugin(); //we instanciate the local notification
    localNotifications.initialize(
      initializationSettings,
    );
  }

  Future showNotification(String title, String body) async {
    var androidDetails = new AndroidNotificationDetails(
        "channelId",
        "Local Notification",
        "This is the description of the Notification, you can write anything",
        importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.show(0, title, body, generalNotificationDetails);
  }

  Future<List<DataStatus>> _loadDataStatus() async {
    List<String> sensorList =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
            .getIdSensors();

    DatabaseReference referenceData = FirebaseDatabase.instance.reference();

    await referenceData
        .child("Devices")
        .child("status")
        .once()
        .then((DataSnapshot dataSnapShot) {
      dataList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        debugPrint(key.toString());
        if (sensorList.contains(key)) {
          DataStatus data = new DataStatus(
              values[key]['name'],
              values[key]['waterT'],
              values[key]['waterEC'],
              values[key]['waterSalt'],
              values[key]['upper'],
              values[key]['lower'],
              values[key]['devices1'],
              values[key]['devices2'],
              key);

          dataList.add(data);
        }
      }
    });
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trang chủ",
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (a, b, c) => HomePage(),
                    transitionDuration: Duration(seconds: 0)));
            return Future.value(false);
          },
          child: FutureBuilder(
            future: _loadDataStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataList.length == 0) {
                return Center(
                  child: Text(
                    "Không có Sensor !",
                    style: TextStyle(fontSize: 23),
                  ),
                );
              }
              return _buildList();
            },
          )),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return WidgetCard(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmDetailsPage(
                      dataStatus: dataList[index],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      dataList[index].name.toString(),
                      style: AppStyle.h3.copyWith(color: Colors.black54),
                    ),
                  ),
                  WidgetRow(
                    text1: 'Nhiệt độ :',
                    text2: dataList[index].waterT,
                    dv: ' °C',
                    color: Colors.orangeAccent,
                  ),
                  WidgetRow(
                    text1: 'EC :',
                    text2: dataList[index].waterEC,
                    dv: ' mS/cm',
                    color: Colors.greenAccent,
                  ),
                  WidgetRow(
                    text1: 'Độ mặn :',
                    text2: dataList[index].waterSalt,
                    dv: ' ppt',
                    color: showNotifi(index) ? Colors.red : Colors.blue,
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool showNotifi(int index) {
    if (dataList[index].waterSalt > dataList[index].upper) {
      String title = dataList[index].name.toString();
      String body = 'Cảnh báo độ mặn vượt ngưỡng mặn trên';
      showNotification(title, body);
      return true;
    } else if (dataList[index].waterSalt < dataList[index].lower) {
      String title = dataList[index].name.toString();
      String body = 'Cảnh báo độ măn dưới ngưỡng măn dưới';
      showNotification(title, body);
      return true;
    }
    return false;
  }
}