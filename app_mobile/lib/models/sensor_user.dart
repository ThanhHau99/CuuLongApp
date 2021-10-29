class SensorUser {
  final String nameSensor;
  final String idSensor;

  SensorUser({this.nameSensor, this.idSensor});

  factory SensorUser.fromJson(Map<String, dynamic> json) {
    return SensorUser(
      nameSensor: json['Name Sensor'],
      idSensor: json['Id Sensor'],
    );
  }
}
