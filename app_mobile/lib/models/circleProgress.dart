import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  double value = 0.0;
  bool isTemp;
  CircleProgress(this.value, this.isTemp);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int maximunValue = isTemp ? 50 : 2; // Temp max is 10,  Hum max is 100

    Paint outerCircle = Paint()
      ..strokeWidth = 12
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    Paint tempArc = Paint()
      ..strokeWidth = 12
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint saltArc = Paint()
      ..strokeWidth = 12
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 12;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / maximunValue);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, isTemp ? tempArc : saltArc);
  }
}
