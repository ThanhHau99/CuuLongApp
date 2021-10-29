import 'package:app_mobile/bloc/add_farm_bloc.dart';
import 'package:app_mobile/models/device_model.dart';
import 'package:app_mobile/services/database.dart';
import 'package:app_mobile/share/app_button.dart';
import 'package:app_mobile/share/app_textflie.dart';
import 'package:app_mobile/share/widget_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddDevice extends StatefulWidget {
  final List<DeviceModel> dataList;
  final List<DeviceModel> listDevice;

  const AddDevice({Key key, this.dataList, this.listDevice}) : super(key: key);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  TextEditingController _txtNameDevice = TextEditingController();
  TextEditingController _txtIdDevice = TextEditingController();

  void addIdDevice(int index) async {
    if (_txtIdDevice.text.isNotEmpty) {
      for (var device in widget.dataList) {
        debugPrint("Device in list: ${device.toString()}");
        if (_txtIdDevice.text.trim() == device.id) {
          debugPrint("Stated update ${_txtIdDevice.text}");
          await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
              .saveIdDevice(
            _txtNameDevice.text.trim(),
            _txtIdDevice.text.trim(),
          );
        }
      }

      widget.listDevice.add(widget.dataList[index]);
    }
  }

  void addNameDevice(int index) async {
    if (_txtNameDevice.text.isNotEmpty) {
      debugPrint("Stated update name");
      DatabaseReference referenceData = FirebaseDatabase.instance.reference();
      referenceData
          .child("Devices")
          .child("control")
          .child(_txtIdDevice.text)
          .child("name")
          .set(_txtNameDevice.text);

      final newName = widget.dataList
          .firstWhere((element) => element.name == widget.dataList[index].name);
      setState(() {
        newName.name = _txtNameDevice.text;
      });
    }
  }

  void onAddClick() {
    setState(() {
      loop:
      if (_txtNameDevice.text != "" && _txtIdDevice.text != "") {
        for (int index = 0; index < widget.dataList.length; index++) {
          print("Sensor list: ${widget.dataList.toString()}");
          if (widget.dataList[index].id == _txtIdDevice.text) {
            addIdDevice(index);
            addNameDevice(index);
            showSuccesAlert();
            setState(() {
              _txtNameDevice.text = '';
              _txtIdDevice.text = '';
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
          message: "Nhập sai id Device",
          textStyle: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }

  void showSuccesAlert() {
    showTopSnackBar(
        context,
        CustomSnackBar.success(
          icon: null,
          backgroundColor: Colors.green,
          message: "Thêm thiết bị mới thành công",
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thiết bị điều khiển'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, widget.listDevice);
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
                      "Thêm thiết bị điều khiển",
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  AppTextFile(
                    textController: _txtNameDevice,
                    lableTextFile: 'Tên thiết bị',
                    onChangefunction: (text) {
                      bloc.nameSink.add(text);
                    },
                  ),
                  AppTextFile(
                    textController: _txtIdDevice,
                    lableTextFile: 'Id thiết bị',
                    hintTextFile: 'sw000001',
                    onChangefunction: (text) {
                      bloc.idDeviceSink.add(text);
                    },
                  ),
                  _buildBtn(bloc),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn(AddFarmBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => AppButton(
          text: 'Thêm Device',
          style: TextStyle(fontSize: 20),
          onpressButton: enable ? onAddClick : null,
        ),
      ),
    );
  }
}
