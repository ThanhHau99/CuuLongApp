import 'dart:ffi';

import 'package:app_mobile/bloc/add_farm_bloc.dart';
import 'package:app_mobile/services/database.dart';
import 'package:app_mobile/share/app_button.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:app_mobile/share/app_textflie.dart';
import 'package:app_mobile/share/widget_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddFarm extends StatefulWidget {
  @override
  _AddFarmState createState() => _AddFarmState();
}

class _AddFarmState extends State<AddFarm> {
  TextEditingController _nameDeviceController = new TextEditingController();
  TextEditingController _idDeviceController = new TextEditingController();

  List<String> listSensors = [];

  @override
  Void initState() {
    super.initState();

    loadDataStatus();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Thêm Sensor",
          ),
        ),
        body: Provider<AddFarmBloc>.value(
          value: AddFarmBloc(),
          child: Consumer<AddFarmBloc>(
            builder: (context, bloc, child) => Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: WidgetCard(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Thêm Sensor",
                        style: TextStyle(fontSize: 23),
                      ),
                    ),
                    AppTextFile(
                      textController: _nameDeviceController,
                      lableTextFile: 'Tên Sensor',
                      onChangefunction: (text) {
                        bloc.nameSink.add(text);
                      },
                    ),
                    AppTextFile(
                      textController: _idDeviceController,
                      lableTextFile: 'Id Sensor',
                      hintTextFile: 'ss000001',
                      onChangefunction: (text) {
                        bloc.idDeviceSink.add(text);
                      },
                    ),
                    _buildButton(bloc),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildButton(AddFarmBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => AppButton(
          text: 'Thêm Sensor',
          style: AppStyle.h6,
          onpressButton: enable ? onAddClick : null,
        ),
      ),
    );
  }

  void loadDataStatus() {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();

    referenceData
        .child("Devices")
        .child("status")
        .once()
        .then((DataSnapshot dataSnapShot) {
      listSensors.clear();

      var keys = dataSnapShot.value.keys;
      //var values = dataSnapShot.value;

      for (var key in keys) {
        debugPrint(key.toString());
        listSensors.add(key);
      }

      setState(() {
        /*Future.delayed(Duration(seconds: 0), () {
          loadData();
        });*/
      });
    });
  }

  void addFarmToAccount() async {
    if (_idDeviceController.text.isNotEmpty) {
      for (var sensor in listSensors) {
        debugPrint("Sensor in list: ${sensor.toString()}");
        if (_idDeviceController.text.toLowerCase() == sensor) {
          debugPrint("Stated update ${_idDeviceController.text}");
          await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
              .updateIdSensor(_idDeviceController.text);
        }
      }

      debugPrint("Sensor id: ${_idDeviceController.text}");
    } else {
      debugPrint("Sensor id is empty");
    }
  }

  void addNameToAccount() async {
    if (_nameDeviceController.text.isNotEmpty) {
      debugPrint("Stated update name");
      DatabaseReference referenceData = FirebaseDatabase.instance.reference();
      referenceData
          .child("Devices")
          .child("status")
          .child(_idDeviceController.text)
          .child("name")
          .set(_nameDeviceController.text);
    }
  }

  void onAddClick() {
    setState(() {
      loop:
      if (_nameDeviceController.text != "" && _idDeviceController.text != "") {
        for (int i = 0; i < listSensors.length; i++) {
          print("Sensor list: ${listSensors.toString()}");
          if (listSensors[i] == _idDeviceController.text) {
            addFarmToAccount();
            addNameToAccount();
            showSuccesAlert();
            setState(() {
              _nameDeviceController.text = '';
              _idDeviceController.text = '';
            });
            break loop;
          }
        }

        showErrAlert();

        setState(() {
          _nameDeviceController.text = '';
          _idDeviceController.text = '';
        });
      }
    });
  }

  void showErrAlert() {
    showTopSnackBar(
        context,
        CustomSnackBar.error(
          icon: null,
          message: "Nhập sai id Sensor",
          textStyle: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }

  void showSuccesAlert() {
    showTopSnackBar(
        context,
        CustomSnackBar.success(
          icon: null,
          backgroundColor: Colors.green,
          message: "Thêm Sensor mới thành công",
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ));
  }
}
