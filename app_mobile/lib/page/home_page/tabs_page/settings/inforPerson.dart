import 'package:app_mobile/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class InforPerson extends StatefulWidget {
  //final String uid;

  //const InforPerson({Key key, this.uid}) : super(key: key);
  @override
  _InforPersonState createState() => _InforPersonState();
}

class _InforPersonState extends State<InforPerson> {
  CollectionReference firebaseFirestore =
      FirebaseFirestore.instance.collection("User");

  String uid = '';
  Future<String> loadUid() async {
    uid = await AuthService.loadUserId();
    debugPrint("Current user logged in: $uid");
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Tài khoản",
      )),
      body: FutureBuilder(
          future: loadUid(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              default:
            }
            return StreamBuilder(
              stream: firebaseFirestore.doc(uid).snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError != null) {
                  DocumentSnapshot user = snapshot.data;

                  return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person,
                                  size: 25,
                                ),
                                title: Text(
                                  "Tên",
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  user['name'],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1.5))),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.email,
                                  size: 25,
                                ),
                                title: Text(
                                  "Địa chỉ Email",
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  user['email'],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1.5))),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  size: 25,
                                ),
                                title: Text(
                                  "Số điện thoại",
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  user['phone'],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1.5))),
                              ),
                            ],
                          ),
                        ],
                      ));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          }),
    );
  }
}
