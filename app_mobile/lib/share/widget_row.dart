import 'package:app_mobile/share/app_style.dart';
import 'package:flutter/material.dart';

class WidgetRow extends StatelessWidget {
  final String text1;
  final double text2;
  final String dv;
  final Color color;
  const WidgetRow({Key key, this.text1, this.text2, this.dv, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: AppStyle.h5,
          ),
          Text(
            (text2).toStringAsFixed(2).toString() + dv,
            style: AppStyle.h5.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
