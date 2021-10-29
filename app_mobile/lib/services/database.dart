import 'package:app_mobile/models/appUser.dart';
import 'package:app_mobile/models/device_user.dart';
import 'package:app_mobile/models/sensor_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // colection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  // firestore
  Future updateUserData(
    String name,
    String phone,
    String email,
    String password,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'email': email,
    });
  }

  // userData from snapshot
  AppUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return AppUser(
      uid: uid,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
    );
  }

  // get user doc Stream
  Stream<AppUser> get userData {
    if (uid != null && uid.isNotEmpty) {
      return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
    } else {
      // Not loggedin
      return null;
    }
  }

  // save sensor id from snapshot
  Future<void> saveIdSensor(String nameSensor, String idSensor) {
    Map<String, dynamic> data = {
      'Name Sensor': nameSensor,
      'Id Sensor': idSensor,
    };
    return userCollection.doc(uid).collection("Sensor").doc(idSensor).set(data);
  }

  // id Sensor list from snapshot

  Future<List<String>> loadIdSensor() async {
    List<String> listIdSensor = [];
    userCollection.doc(uid).collection("Sensor").snapshots().listen((snapshot) {
      snapshot.docs.map((e) {
        var data = e.data();

        SensorUser sensorUser = SensorUser.fromJson(data);

        listIdSensor.add(sensorUser.idSensor);
      }).toList();
    });

    return listIdSensor;
  }

  // delete id Sensor
  Future<void> deleteIdSensor(String idSensor) async {
    userCollection.doc(uid).collection("Sensor").doc(idSensor).delete();
  }

  // save Device id from snapshot
  Future<void> saveIdDevice(String nameDevice, String idDevice) {
    Map<String, dynamic> data = {
      'Name Device': nameDevice,
      'Id Device': idDevice,
    };
    return userCollection.doc(uid).collection("Device").doc(idDevice).set(data);
  }

  // id Device list

  Future<List<String>> loadIdDevice() async {
    List<String> listIdDevice = [];
    userCollection.doc(uid).collection("Device").snapshots().listen((snapshot) {
      snapshot.docs.map((e) {
        var data = e.data();

        DeviceUser deviceUser = DeviceUser.fromJson(data);

        listIdDevice.add(deviceUser.idDevice);
      }).toList();
    });

    return listIdDevice;
  }

  // delete id Device
  Future<void> deleteIdDevice(String idDevice) async {
    userCollection.doc(uid).collection("Device").doc(idDevice).delete();
  }
}
