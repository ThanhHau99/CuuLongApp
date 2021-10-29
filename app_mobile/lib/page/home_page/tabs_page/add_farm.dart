import 'package:app_mobile/bloc/add_farm_bloc.dart';
import 'package:app_mobile/models/data_status.dart';
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

class AddSensor extends StatefulWidget {
  final List<DataStatus> dataList;
  final List<DataStatus> listSensor;

  const AddSensor({Key key, this.dataList, this.listSensor}) : super(key: key);
  @override
  _AddSensorState createState() => _AddSensorState();
}

class _AddSensorState extends State<AddSensor> {
  TextEditingController _nameDeviceController = new TextEditingController();
  TextEditingController _idDeviceController = new TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Thêm Sensor",
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                print("back");
                Navigator.pop(context, widget.listSensor);
              }),
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

  void addFarmToAccount(int index) async {
    if (_idDeviceController.text.isNotEmpty) {
      for (var sensor in widget.dataList) {
        debugPrint("Sensor in list: ${sensor.id}");
        if (_idDeviceController.text.trim() == sensor.id) {
          debugPrint("Stated update ${_idDeviceController.text}");
          await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
              .saveIdSensor(
            _nameDeviceController.text.trim(),
            _idDeviceController.text.trim(),
          );
        }
      }
      widget.listSensor.add(widget.dataList[index]);
    }
  }

  void addNameToAccount(int index) async {
    if (_nameDeviceController.text.isNotEmpty) {
      debugPrint("Stated update name");
      DatabaseReference referenceData = FirebaseDatabase.instance.reference();
      referenceData
          .child("Devices")
          .child("status")
          .child(_idDeviceController.text)
          .child("name")
          .set(_nameDeviceController.text);
      final newName = widget.dataList
          .firstWhere((element) => element.name == widget.dataList[index].name);
      setState(() {
        newName.name = _nameDeviceController.text;
      });
    }
  }

  void onAddClick() {
    setState(() {
      loop:
      if (_nameDeviceController.text != "" && _idDeviceController.text != "") {
        for (int index = 0; index < widget.dataList.length; index++) {
          print("Sensor list: ${widget.dataList.toString()}");
          if (widget.dataList[index].id == _idDeviceController.text) {
            addFarmToAccount(index);
            addNameToAccount(index);
            showSuccesAlert();

            setState(() {
              _nameDeviceController.text = '';
              _idDeviceController.text = '';
            });
            break loop;
          }
        }

        showErrAlert();
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
