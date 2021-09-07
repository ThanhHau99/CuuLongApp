import 'package:app_mobile/models/device_model.dart';

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

  @override
  void initState() {
    super.initState();
    _loadDataDevice();
  }

  void _loadDataDevice() async {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();
    List<String> deviceList =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
            .getIdDevices();

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
        if (deviceList.contains(key)) {
          DeviceModel data = new DeviceModel(
            key,
            values[key]['name'],
            values[key]['device1'],
            values[key]['device2'],
          );

          dataList.add(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Điều khiển',
          ),
        ),
        body:
            dataList.length == 0 ? _buildWaitContainer() : _buildListDevices());
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
                'Không có Devices',
                style: TextStyle(fontSize: 23),
              ),
            );
          }
        });
  }

  Widget _buildListDevices() {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (_, index) {
        return Card(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                Text(
                  'Tủ điều khiển ${dataList[index].name}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
                            dataList[index].device1 = !dataList[index].device1;

                            updateData(
                              dataList[index].id,
                              'device1',
                              dataList[index].device1,
                            );
                          });
                        },
                        child: SWitchButton(
                          value: dataList[index].device1,
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
                          dataList[index].device2 = !dataList[index].device2;

                          updateData(dataList[index].id, 'device2',
                              dataList[index].device2);
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
