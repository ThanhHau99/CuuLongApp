import 'package:app_mobile/page/wrapper/connect_page.dart';
import 'package:app_mobile/page/wrapper/plash_screen.dart';
import 'package:flutter/material.dart';

class WrapperPage extends StatelessWidget {
  final String uid;
  const WrapperPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashPgae();
          } else {
            return ConnectPage(
              uid: uid,
            );
          }
        });
  }
}
