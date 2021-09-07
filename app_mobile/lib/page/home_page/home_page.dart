import 'package:app_mobile/page/home_page/tabs_page/add_farm.dart';
import 'package:app_mobile/page/home_page/tabs_page/control_page/add_devices.dart';

import 'package:app_mobile/page/home_page/tabs_page/control_page/control_page.dart';
import 'package:app_mobile/page/home_page/tabs_page/dataScreen.dart';
import 'package:app_mobile/page/home_page/tabs_page/settings/settingsForm.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabindex = 0;
  var tabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      DataScreen(),
      AddFarm(),
      ControlPage(),
      AddDevice(),
      SettingsForm(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[tabindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabindex,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 13),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Trang chủ"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: "Thêm Sensor"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.control_camera_rounded,
              ),
              label: "Điều khiển"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_to_drive,
              ),
              label: "Thêm Devices"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: "Cài đặt"),
        ],
        onTap: (index) {
          setState(() {
            tabindex = index;
          });
        },
      ),
    );
  }
}
