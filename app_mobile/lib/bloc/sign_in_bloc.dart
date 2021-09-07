import 'dart:async';

import 'package:app_mobile/share/valid.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc {
  SignInBloc() {
    btnValidation();
  }

  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validation.isEmailValid(email)) {
      sink.add(null);
      return;
    }
    sink.add("Email bị sai");
  });

  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (Validation.isPassValid(pass)) {
      sink.add(null);
      return;
    }
    sink.add("Mật khẩu quá ngắn");
  });

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  //ktra dữ liệu có hợp lệ để btn sáng màu hay không

  btnValidation() {
    Rx.combineLatest2(_emailSubject, _passSubject, (email, pass) {
      return Validation.isEmailValid(email) && Validation.isPassValid(pass);
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  void disponse() {
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
