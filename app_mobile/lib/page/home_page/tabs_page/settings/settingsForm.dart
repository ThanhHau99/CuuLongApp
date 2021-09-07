import 'package:app_mobile/page/home_page/tabs_page/settings/inforPerson.dart';
import 'package:app_mobile/page/wrapper/connect_page.dart';
import 'package:app_mobile/services/auth.dart';
import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cài đặt",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InforPerson()));
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Tài khoản",
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.navigate_next_sharp,
                          color: Colors.black,
                        )
                      ]),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ConnectPage()));
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Đăng xuất",
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.navigate_next_sharp,
                          color: Colors.black,
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
