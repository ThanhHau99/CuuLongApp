import 'package:app_mobile/bloc/add_farm_bloc.dart';
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
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  List<String> listDevices = [];
  TextEditingController _txtNameDevice = TextEditingController();
  TextEditingController _txtIdDevice = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataControl();
  }

  void loadDataControl() {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();

    referenceData
        .child("Devices")
        .child("control")
        .once()
        .then((DataSnapshot dataSnapShot) {
      listDevices.clear();

      var keys = dataSnapShot.value.keys;
      //var values = dataSnapShot.value;

      for (var key in keys) {
        debugPrint(key.toString());
        listDevices.add(key);
      }

      setState(() {
        /*Future.delayed(Duration(seconds: 0), () {
          loadData();
        });*/
      });
    });
  }

  void addIdDevice() async {
    if (_txtIdDevice.text.isNotEmpty) {
      for (var device in listDevices) {
        debugPrint("Device in list: ${device.toString()}");
        if (_txtIdDevice.text.toLowerCase() == device) {
          debugPrint("Stated update ${_txtIdDevice.text}");
          await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
              .updateIdDevices(_txtIdDevice.text);
        }
      }

      debugPrint("Device id: ${_txtIdDevice.text}");
    } else {
      debugPrint("Device id is empty");
    }
  }

  void addNameDevice() async {
    if (_txtNameDevice.text.isNotEmpty) {
      debugPrint("Stated update name");
      DatabaseReference referenceData = FirebaseDatabase.instance.reference();
      referenceData
          .child("Devices")
          .child("control")
          .child(_txtIdDevice.text)
          .child("name")
          .set(_txtNameDevice.text);
    }
  }

  void onAddClick() {
    setState(() {
      loop:
      if (_txtNameDevice.text != "" && _txtIdDevice.text != "") {
        for (int i = 0; i < listDevices.length; i++) {
          print("Sensor list: ${listDevices.toString()}");
          if (listDevices[i] == _txtIdDevice.text) {
            addIdDevice();
            addNameDevice();
            showSuccesAlert();
            setState(() {
              _txtNameDevice.text = '';
              _txtIdDevice.text = '';
            });
            break loop;
          }
        }

        showErrAlert();

        setState(() {
          _txtNameDevice.text = '';
          _txtIdDevice.text = '';
        });
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
