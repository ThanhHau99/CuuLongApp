import 'package:app_mobile/page/authentication/sign_in_page.dart';
import 'package:app_mobile/page/authentication/sign_up_dart.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInPage(
        toggleView: toggleView,
      );
    } else {
      return SignUpPage(
        toggleView: toggleView,
      );
    }
  }
}
