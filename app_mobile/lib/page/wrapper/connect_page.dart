import 'package:app_mobile/page/home_page/home_page.dart';
import 'package:app_mobile/page/wrapper/authentication.dart';
import 'package:flutter/material.dart';

class ConnectPage extends StatelessWidget {
  final String uid;

  const ConnectPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("uid : $uid");
    if (uid != null && uid.isNotEmpty) {
      return HomePage();
    } else {
      return AuthenticationPage();
    }
  }
}
