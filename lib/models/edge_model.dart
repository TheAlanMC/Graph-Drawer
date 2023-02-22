import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/widgets.dart';

class EdgeModel extends StatelessWidget {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String text;
  final double radius;

  const EdgeModel({super.key, required this.x1, required this.y1, required this.x2, required this.y2, required this.text, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (x2 == x1 && y2 == y1) {
      return CustomPaint(painter: Edge(posX1: x1, posY1: y1 - radius, posX2: x2 - radius, posY2: y2, text: text, radius: radius, auto: true));
    }
    if ((x2 - x1) > 100) {
      return CustomPaint(painter: Edge(posX1: x1 + radius, posY1: y1, posX2: x2 - radius, posY2: y2, text: text, radius: radius));
    } else if ((x1 - x2) > 100) {
      return CustomPaint(painter: Edge(posX1: x1 - radius, posY1: y1, posX2: x2 + radius, posY2: y2, text: text, radius: radius));
    } else if ((y2 - y1) > 100) {
      return CustomPaint(painter: Edge(posX1: x1, posY1: y1 + radius, posX2: x2, posY2: y2 - radius, text: text, radius: radius));
    } else if ((y1 - y2) > 100) {
      return CustomPaint(painter: Edge(posX1: x1, posY1: y1, posX2: x2, posY2: y2 + radius, text: text, radius: radius));
    } else if (x2 > x1) {
      return CustomPaint(painter: Edge(posX1: x1 + radius, posY1: y1, posX2: x2 - radius, posY2: y2, text: text, radius: radius));
    } else if (x1 > x2) {
      return CustomPaint(painter: Edge(posX1: x1 - radius, posY1: y1, posX2: x2 + radius, posY2: y2, text: text, radius: radius));
    } else if (y2 > y1) {
      return CustomPaint(painter: Edge(posX1: x1, posY1: y1 + radius, posX2: x2 - radius, posY2: y2, text: text, radius: radius));
    } else if (y1 > y2) {
      return CustomPaint(painter: Edge(posX1: x1, posY1: y1 - radius, posX2: x2, posY2: y2 + radius, text: text, radius: radius));
    }
    return CustomPaint(painter: Edge(posX1: x1, posY1: y1, posX2: x2, posY2: y2, text: text, radius: radius));
  }

  EdgeModel copyWith({
    double? x1,
    double? y1,
    double? x2,
    double? y2,
    String? text,
    int? start,
    int? end,
  }) {
    return EdgeModel(
      x1: x1 ?? this.x1,
      y1: y1 ?? this.y1,
      x2: x2 ?? this.x2,
      y2: y2 ?? this.y2,
      text: text ?? this.text,
      radius: radius,
    );
  }

  bool isInside(double dx, double dy) {
    if (dx >= x2 - radius - 20 && dx <= x2 + radius + 20 && dy >= y2 - radius - 20 && dy <= y2 + radius + 20) {
      return true;
    }
    return false;
  }
}
