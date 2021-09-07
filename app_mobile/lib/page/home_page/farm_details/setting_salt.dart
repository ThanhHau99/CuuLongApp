import 'package:app_mobile/bloc/set_salt_bloc.dart';
import 'package:app_mobile/models/data_status.dart';
import 'package:app_mobile/share/app_button.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SettingSalt extends StatefulWidget {
  final DataStatus dataStatus;

  const SettingSalt({Key key, this.dataStatus}) : super(key: key);
  @override
  _SettingSaltState createState() => _SettingSaltState(dataStatus);
}

class _SettingSaltState extends State<SettingSalt> {
  final DataStatus dataStatus;
  TextEditingController controllerUpper = new TextEditingController();
  TextEditingController controllerLower = new TextEditingController();

  _SettingSaltState(this.dataStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt ngưỡng mặn',
        ),
      ),
      body: Provider<SetSaltBloc>.value(
        value: SetSaltBloc(),
        child: Consumer<SetSaltBloc>(
          builder: (context, bloc, child) => Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      '${dataStatus.name}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _upperWidget(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    _lowerWidget(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    _buildButton(bloc),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _upperWidget(SetSaltBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.upperStream,
      child: Consumer<String>(
        builder: (context, mess, child) => TextField(
          controller: controllerUpper,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              errorText: mess,
              labelText: "Ngưỡng mặn trên hiện tại : ${dataStatus.upper} ",
              icon: Icon(Icons.broken_image_outlined),
              labelStyle: TextStyle(fontSize: 18)),
          onChanged: (val) {
            bloc.upperSink.add(val);
          },
        ),
      ),
    );
  }

  Widget _lowerWidget(SetSaltBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.lowerStream,
      child: Consumer<String>(
        builder: (context, mess, child) => TextField(
          controller: controllerLower,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              errorText: mess,
              labelText: "Ngưỡng mặn dưới hiện tại : ${dataStatus.lower} ",
              icon: Icon(Icons.broken_image_outlined),
              labelStyle: TextStyle(fontSize: 18)),
          onChanged: (val) {
            bloc.lowerSink.add(val);
          },
        ),
      ),
    );
  }

  Widget _buildButton(SetSaltBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => AppButton(
          onpressButton: enable
              ? () {
                  setState(() {
                    onClickUpdate();
                  });
                }
              : null,
          text: 'Cập nhật',
          style: AppStyle.h6,
        ),
      ),
    );
  }

  void updateData() {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference();
    referenceData
        .child("Devices")
        .child("status")
        .child(dataStatus.id)
        .child("upper")
        .set(double.parse(controllerUpper.text));
    print(controllerUpper.text);

    referenceData
        .child("Devices")
        .child("status")
        .child(dataStatus.id)
        .child("lower")
        .set(double.parse(controllerLower.text));
    print(controllerLower.text);
  }

  void onClickUpdate() {
    if (double.parse(controllerUpper.text) >
        double.parse(controllerLower.text)) {
      updateData();
      alertSuccess();
      setState(() {
        dataStatus.upper = double.parse(controllerUpper.text);
        dataStatus.lower = double.parse(controllerLower.text);
        controllerUpper.text = '';
        controllerLower.text = '';
      });
    } else {
      alertWarning();
      setState(() {
        controllerUpper.text = '';
        controllerLower.text = '';
      });
    }
  }

  void alertSuccess() {
    showTopSnackBar(
        context,
        CustomSnackBar.success(
          backgroundColor: Colors.green,
          message: "Cập nhật ngưỡng mặn thành công",
          textStyle: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }

  void alertWarning() {
    showTopSnackBar(
        context,
        CustomSnackBar.error(
          backgroundColor: Colors.redAccent,
          message: "Cài đặt ngưỡng mặn sai!",
          textStyle: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}
