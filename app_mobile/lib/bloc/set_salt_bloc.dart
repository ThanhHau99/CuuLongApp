import 'dart:async';

import 'package:app_mobile/share/valid.dart';
import 'package:rxdart/rxdart.dart';

class SetSaltBloc {
  SetSaltBloc() {
    btnValidation();
  }

  final _upperSubject = BehaviorSubject<String>();
  final _lowerSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var upperValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (upper, sink) {
    if (Validation.isnumberValid(upper)) {
      sink.add(null);
      return;
    }
    sink.add("Giá trị ngưỡng mặn trên sai");
  });

  var lowerValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (lower, sink) {
    if (Validation.isnumberValid(lower)) {
      sink.add(null);
      return;
    }
    sink.add("Giá trị ngưỡng mặn dưới sai");
  });

  Stream<String> get upperStream =>
      _upperSubject.stream.transform(upperValidation);
  Sink<String> get upperSink => _upperSubject.sink;

  Stream<String> get lowerStream =>
      _lowerSubject.stream.transform(lowerValidation);
  Sink<String> get lowerSink => _lowerSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  //ktra dữ liệu có hợp lệ để btn sáng màu hay không

  btnValidation() {
    Rx.combineLatest2(_upperSubject, _lowerSubject, (upper, lower) {
      return Validation.isnumberValid(upper) && Validation.isnumberValid(lower);
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  void disponse() {
    _upperSubject.close();
    _lowerSubject.close();
    _btnSubject.close();
  }
}
