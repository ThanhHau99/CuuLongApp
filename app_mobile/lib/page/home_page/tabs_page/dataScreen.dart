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
import 'package:flutter/cupertino.dart';
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
    _loadDataStatus();

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

  void _loadDataStatus() async {
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
      setState(() {
        //
      });
    });
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
          child: dataList.length == 0 ? _buildWaitContainer() : _buildList(),
        ));
  }

  Widget _buildWaitContainer() {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 7)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(
                'Không có Sensor!',
                style: TextStyle(fontSize: 23),
              ),
            );
          }
        });
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataList[index].name.toString(),
                          style: AppStyle.h3.copyWith(color: Colors.black54),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.black54,
                            size: 25,
                          ),
                          onTap: () {
                            print("kkkkkkk");
                            showArlet(index);
                          },
                        )
                      ],
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

  void deleteData(int index) async {
    setState(() {
      print("delete: ${dataList[index].id}");
      dataList.removeAt(index);
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .deleteIdSensor(index);
  }

  void showArlet(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceInOut,
        title: Text(
          "Thông báo",
          style: TextStyle(fontSize: 23),
        ),
        content: Text(
          "Bạn có muốn xóa Sensor?",
          style: TextStyle(fontSize: 19),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Đồng ý", style: TextStyle(fontSize: 20)),
            onPressed: () {
              print("Dong y");
              deleteData(index);
              Navigator.pop(context);
            },
            isDefaultAction: true, // Chỉnh in đậm cho button
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // chỉnh màu đỏ cho nút bấm
            child: Text("Hủy bỏ", style: TextStyle(fontSize: 20)),
            onPressed: () {
              print("Hủy bỏ");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
