import 'dart:async';

import 'package:app_mobile/share/valid.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final _nameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _rePassSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  SignUpBloc() {
    btnValidation();
  }

  var nameValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (Validation.isName(name)) {
      sink.add(null);
      return;
    }
    sink.add('Vui lòng nhập tên vào');
  });

  var phoneValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (Validation.isPhoneValid(phone)) {
      sink.add(null);
      return;
    }
    sink.add('Vui lòng nhập số điện thoại vào');
  });

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validation.isEmailValid(email)) {
      sink.add(null);
      return;
    }
    sink.add('Email nhập sai');
  });

  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (Validation.isPassValid(pass)) {
      sink.add(null);
      return;
    }
    sink.add('Mật khẩu quá ngắn');
  });

  Stream<String> get nameStream =>
      _nameSubject.stream.transform(nameValidation);
  Sink<String> get nameSink => _nameSubject.sink;

  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(phoneValidation);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<String> get rePassStream => _rePassSubject.stream;
  Sink<String> get rePassSink => _rePassSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  // ktra
  // rePass() {
  //   if (rePassStream == passStream) {
  //     rePassSink.add(null);
  //     return;
  //   }
  //   rePassSink.add('Nhập lại mật khẩu');
  // }

  btnValidation() {
    Rx.combineLatest4(_nameSubject, _phoneSubject, _emailSubject, _passSubject,
        (name, phone, email, pass) {
      return Validation.isName(name) &&
          Validation.isPhoneValid(phone) &&
          Validation.isEmailValid(email) &&
          Validation.isPassValid(pass);
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  void disponse() {
    _nameSubject.close();
    _phoneSubject.close();
    _emailSubject.close();
    _passSubject.close();
    _rePassSubject.close();
    _btnSubject.close();
  }
}
