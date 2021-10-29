import 'package:app_mobile/models/sensor_user.dart';
import 'package:app_mobile/page/wrapper/wrapper.dart';
import 'package:app_mobile/services/auth.dart';
import 'package:app_mobile/services/database.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String uid = '';
List<SensorUser> listSensor = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  uid = await AuthService.loadUserId();
  debugPrint("Current user logged in: $uid");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.green),
          backgroundColor: Color(0xfffafafa),
          elevation: 1,
          textTheme: TextTheme(
            headline6: AppStyle.h4.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: WrapperPage(
        uid: uid,
      ),
    );
  }
}
