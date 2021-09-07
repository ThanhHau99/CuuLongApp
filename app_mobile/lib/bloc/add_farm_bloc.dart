import 'dart:async';

import 'package:rxdart/rxdart.dart';

class AddFarmBloc {
  AddFarmBloc() {
    btnValidation();
  }

  final _nameSubject = BehaviorSubject<String>();
  final _idDeviceSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  Stream<String> get nameStream => _nameSubject.stream;
  Sink<String> get nameSink => _nameSubject.sink;

  Stream<String> get idDeviceStream => _idDeviceSubject.stream;
  Sink<String> get idDeviceSink => _idDeviceSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  //ktra dữ liệu có hợp lệ để btn sáng màu hay không

  btnValidation() {
    Rx.combineLatest2(_nameSubject, _idDeviceSubject, (name, idDevice) {
      return name.toString().isNotEmpty && idDevice.toString().isNotEmpty;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  void disponse() {
    _nameSubject.close();
    _idDeviceSubject.close();
    _btnSubject.close();
  }
}
