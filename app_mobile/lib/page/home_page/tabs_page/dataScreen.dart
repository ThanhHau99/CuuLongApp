import 'package:app_mobile/main.dart';
import 'package:app_mobile/models/data_status.dart';
import 'package:app_mobile/models/sensor_user.dart';
import 'package:app_mobile/page/home_page/farm_details/farmDetails_page.dart';
import 'package:app_mobile/page/home_page/home_page.dart';
import 'package:app_mobile/page/home_page/tabs_page/add_farm.dart';
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
  List<DataStatus> listSensor = [];
  FlutterLocalNotificationsPlugin localNotifications;
  DatabaseService databaseService;
  List<SensorUser> id;

  @override
  void initState() {
    super.initState();
    _loadData();

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

  void _loadData() async {
    List<String> idSensor =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
            .loadIdSensor();

    print("idSensor: ${idSensor.length}");

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

        if (idSensor.contains(key)) {
          listSensor.add(data);
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
            "Sensor",
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSensor(
                        dataList: dataList,
                        listSensor: listSensor,
                      ),
                    ),
                  );
                  setState(() {
                    listSensor = result as List<DataStatus>;
                  });
                })
          ],
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
          child: listSensor.length == 0 ? _buildWaitContainer() : _buildList(),
        ));
  }

  Widget _buildWaitContainer() {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 10)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(
                'Kh??ng c?? Sensor!',
                style: TextStyle(fontSize: 23),
              ),
            );
          }
        });
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: listSensor.length,
        itemBuilder: (context, index) {
          return WidgetCard(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmDetailsPage(
                      dataStatus: listSensor[index],
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
                          listSensor[index].name.toString(),
                          style: AppStyle.h3.copyWith(color: Colors.black54),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.black54,
                            size: 25,
                          ),
                          onTap: () {
                            print("delete");
                            showArlet(listSensor[index], index);
                          },
                        )
                      ],
                    ),
                  ),
                  WidgetRow(
                    text1: 'Nhi???t ????? :',
                    text2: listSensor[index].waterT,
                    dv: ' ??C',
                    color: Colors.orangeAccent,
                  ),
                  WidgetRow(
                    text1: 'EC :',
                    text2: listSensor[index].waterEC,
                    dv: ' mS/cm',
                    color: Colors.greenAccent,
                  ),
                  WidgetRow(
                    text1: '????? m???n :',
                    text2: listSensor[index].waterSalt,
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
    if (listSensor[index].waterSalt > listSensor[index].upper) {
      String title = listSensor[index].name.toString();
      String body = 'C???nh b??o ????? m???n v?????t ng?????ng m???n tr??n';
      showNotification(title, body);
      return true;
    } else if (listSensor[index].waterSalt < listSensor[index].lower) {
      String title = listSensor[index].name.toString();
      String body = 'C???nh b??o ????? m??n d?????i ng?????ng m??n d?????i';
      showNotification(title, body);
      return true;
    }
    return false;
  }

  void deleteData(String idSensor, int index) async {
    setState(() {
      listSensor.removeAt(index);
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .deleteIdSensor(idSensor);
  }

  void showArlet(DataStatus sensor, int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceInOut,
        title: Text(
          "Th??ng b??o",
          style: TextStyle(fontSize: 23),
        ),
        content: Text(
          "B???n c?? mu???n x??a Sensor?",
          style: TextStyle(fontSize: 19),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("?????ng ??", style: TextStyle(fontSize: 20)),
            onPressed: () {
              print("Dong y");
              deleteData(sensor.id, index);
              Navigator.pop(context);
            },
            isDefaultAction: true, // Ch???nh in ?????m cho button
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // ch???nh m??u ????? cho n??t b???m
            child: Text("H???y b???", style: TextStyle(fontSize: 20)),
            onPressed: () {
              print("H???y b???");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
