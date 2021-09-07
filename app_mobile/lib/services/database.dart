import 'package:app_mobile/models/appUser.dart';
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
    List idSensors,
    List idDevices,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'email': email,
      'idSensors': idSensors,
      'idDevices': idDevices,
    });
  }

  Future getIdSensors() async {
    AppUser appUser = await userData.first;
    return appUser.idSensors;
  }

  Future getIdDevices() async {
    AppUser appUser = await userData.first;
    return appUser.idDevices;
  }

  Future updateIdSensor(
    String idSensor,
  ) async {
    AppUser appUser = await userData.first;
    debugPrint("App User to update sensor list: ${appUser.uid}");

    var existedList = appUser.idSensors;
    existedList.add(idSensor);

    await userCollection.doc(uid).set({
      'email': appUser.email,
      'name': appUser.name,
      'phone': appUser.phone,
      //'password': appUser.password,
      'idSensors': existedList,
      'idDevices': appUser.idDevices,
    });
  }

  Future updateIdDevices(
    String idDevice,
  ) async {
    AppUser appUser = await userData.first;
    debugPrint("App User to update sensor list: ${appUser.uid}");

    var existedList = appUser.idDevices;
    existedList.add(idDevice);

    await userCollection.doc(uid).set({
      'email': appUser.email,
      'name': appUser.name,
      'phone': appUser.phone,
      //'password': appUser.password,
      'idSensors': appUser.idSensors,
      'idDevices': existedList,
    });
  }

  // user list from snapshot
  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      List<String> sensors = [];
      data['idSensors'].forEach((element) {
        sensors.add(element);
      });

      List<String> devices = [];
      data['idDevices'].forEach((element) {
        devices.add(element);
      });

      return AppUser(
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        //password: doc.data()['password'] ?? '0',

        idSensors: sensors,
        idDevices: devices,
      );
    }).toList();
  }

  // userData from snapshot
  AppUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    List<String> sensors = [];
    data['idSensors'].forEach((element) {
      sensors.add(element);
    });

    List<String> devices = [];
    data['idDevices'].forEach((element) {
      devices.add(element);
    });

    return AppUser(
      uid: uid,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      //password: snapshot.data()['password'],

      idSensors: sensors,
      idDevices: devices,
    );
  }

  // get user stream
  Stream<List<AppUser>> get brews {
    return userCollection.snapshots().map((_userListFromSnapshot));
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
}
