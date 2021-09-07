import 'dart:convert';

import 'package:app_mobile/models/appUser.dart';

class CustomClassName {
  final String uid;

  CustomClassName({this.uid});
}

class UserData {
  AppUser fromJson(String json) {
    AppUser appUser = AppUser();
    appUser.uid = jsonDecode(json)['uid'];
    appUser.name = jsonDecode(json)['name'];
    appUser.email = jsonDecode(json)['email'];
    appUser.phone = jsonDecode(json)['phone'];
    appUser.password = jsonDecode(json)['password'];

    var sensorsJSON = jsonDecode(json)['idSensors'];
    appUser.idSensors = sensorsJSON != null ? List.from(sensorsJSON) : null;

    var devicesJSON = jsonDecode(json)['idDevices'];
    appUser.idDevices = devicesJSON != null ? List.from(devicesJSON) : null;
    return appUser;
  }

  Map<String, dynamic> toJson(AppUser user) => {
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'password': user.password,
        'idSensors': user.idSensors,
        'idDevices': user.idDevices
      };
}
