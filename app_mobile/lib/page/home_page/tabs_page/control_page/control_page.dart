import 'dart:convert';

import 'package:app_mobile/models/device_model.dart';
import 'package:app_mobile/page/home_page/tabs_page/control_page/add_devices.dart';

import 'package:app_mobile/services/database.dart';
import 'package:app_mobile/share/switch_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  List<DeviceModel> dataList = [];
  List<DeviceModel> listDevice = [];

  @override
  void initState() {
    super.initState();
    _loadDataDevice();
  }

  void _loadDataDevice() async {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();
    List<String> deviceList =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
            .loadIdDevice();

    await referenceData
        .child("Devices")
        .child("control")
        .once()
        .then((DataSnapshot dataSnapShot) {
      dataList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        debugPrint(key.toString());
        DeviceModel data = new DeviceModel(
          key,
          values[key]['name'],
          values[key]['device1'],
          values[key]['device2'],
        );

        dataList.add(data);

        if (deviceList.contains(key)) {
          listDevice.add(data);
        }
      }
      setState(() {
        //
      });
    });
  }

  void updateData(String id, String device, bool value) async {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();
    await referenceData
        .child("Devices")
        .child("control")
        .child(id)
        .child(device)
        .set(value);
    print(value);
  }

  void deleteData(String idDevice, int index) async {
    print("delete: ${listDevice[index].id}");

    await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        .deleteIdDevice(idDevice);
    setState(() {
      listDevice.removeAt(index);
    });
  }

  void showArlet(DeviceModel device, int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceInOut,
        title: Text(
          "Thông báo",
          style: TextStyle(fontSize: 23),
        ),
        content: Text(
          "Bạn có muốn xóa Device?",
          style: TextStyle(fontSize: 19),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Đồng ý", style: TextStyle(fontSize: 20)),
            onPressed: () {
              print("Dong y");
              deleteData(device.id, index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Điều khiển',
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDevice(
                        dataList: dataList,
                        listDevice: listDevice,
                      ),
                    ),
                  );
                  setState(() {
                    listDevice = result;
                  });
                })
          ],
        ),
        body: listDevice.length == 0
            ? _buildWaitContainer()
            : _buildListDevices());
  }

  Widget _buildWaitContainer() {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(
                'Không có Devices!',
                style: TextStyle(fontSize: 23),
              ),
            );
          }
        });
  }

  Widget _buildListDevices() {
    return ListView.builder(
      itemCount: listDevice.length,
      itemBuilder: (_, index) {
        return Card(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tủ điều khiển ${listDevice[index].name}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.black54,
                        size: 25,
                      ),
                      onTap: () {
                        showArlet(listDevice[index], index);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Color(0xff00D100),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Máy 1",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            listDevice[index].device1 =
                                !listDevice[index].device1;

                            updateData(
                              listDevice[index].id,
                              'device1',
                              listDevice[index].device1,
                            );
                          });
                        },
                        child: SWitchButton(
                          value: listDevice[index].device1,
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Color(0xff00D100),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Máy 2",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listDevice[index].device2 =
                              !listDevice[index].device2;

                          updateData(listDevice[index].id, 'device2',
                              listDevice[index].device2);
                        });
                      },
                      child: SWitchButton(
                        value: dataList[index].device2,
                      ),
                    )
                  ],
                ),
              ])),
        );
      },
    );
  }
}
