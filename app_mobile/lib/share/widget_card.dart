import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final Widget child;

  const WidgetCard({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(17),
        child: child,
      ),
    );
  }
}
