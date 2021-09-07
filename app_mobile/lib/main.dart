import 'package:app_mobile/page/wrapper/wrapper.dart';
import 'package:app_mobile/services/auth.dart';
import 'package:app_mobile/share/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String uid = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  uid = await AuthService.loadUserId();
  debugPrint("Current user logged in: $uid");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
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
      //home: SettingsForm(),
      home: WrapperPage(
        uid: uid,
      ),
    );
  }
}
