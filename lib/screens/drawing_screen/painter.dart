import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:privateroom/screens/drawing_screen/drawing_points.dart';

class Painter extends CustomPainter {
  Painter({
    @required this.points,
  });

  final List<DrawingPoints> points;
  final List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i].offset, points[i + 1].offset, points[i].paint);
      } else if (points[i] != null && points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[i].offset);
        offsetPoints
            .add(Offset(points[i].offset.dx + 0.1, points[i].offset.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, points[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
