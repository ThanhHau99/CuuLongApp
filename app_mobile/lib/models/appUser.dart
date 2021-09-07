class AppUser {
  String uid;
  String name;
  String email;
  String phone;
  String password;
  List idSensors;
  List idDevices;

  AppUser({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.idSensors,
    this.idDevices,
  });
}
