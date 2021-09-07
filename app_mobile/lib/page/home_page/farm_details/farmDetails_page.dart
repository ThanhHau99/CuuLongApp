import 'package:app_mobile/models/data_status.dart';
import 'package:app_mobile/page/home_page/farm_details/chart.dart';
import 'package:app_mobile/page/home_page/farm_details/setting_salt.dart';
import 'package:flutter/material.dart';

class FarmDetailsPage extends StatelessWidget {
  final DataStatus dataStatus;
  const FarmDetailsPage({Key key, this.dataStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${dataStatus.name}",
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          children: [
            InkWell(
              child: Card(
                margin: EdgeInsets.only(bottom: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cài đặt ngưỡng mặn",
                        style: TextStyle(fontSize: 23),
                      ),
                      Icon(Icons.navigate_next_sharp)
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => SettingSalt(
                              dataStatus: dataStatus,
                            )));
              },
            ),
            InkWell(
              child: Card(
                margin: EdgeInsets.only(bottom: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Biểu đồ",
                        style: TextStyle(fontSize: 23),
                      ),
                      Icon(Icons.navigate_next_sharp)
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chart(
                              dataStatus: dataStatus,
                            )));
              },
            )
          ],
        ),
      ),
    );
  }
}
