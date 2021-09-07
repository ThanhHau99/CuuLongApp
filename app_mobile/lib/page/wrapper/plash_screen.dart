import 'package:app_mobile/share/app_images.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:flutter/material.dart';

class SplashPgae extends StatelessWidget {
  const SplashPgae({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logoApp),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logoFuvitech, width: 40, height: 40),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Fuvitech",
                    style: AppStyle.h7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
