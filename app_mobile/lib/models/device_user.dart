class DeviceUser {
  final String nameDevice;
  final String idDevice;

  DeviceUser({this.nameDevice, this.idDevice});

  factory DeviceUser.fromJson(Map<String, dynamic> json) {
    return DeviceUser(
      nameDevice: json['Name Device'],
      idDevice: json['Id Device'],
    );
  }
}
