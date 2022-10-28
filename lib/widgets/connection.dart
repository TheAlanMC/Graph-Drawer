import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/widgets.dart';

class Connection extends StatelessWidget {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String text;

  const Connection({super.key, required this.x1, required this.y1, required this.x2, required this.y2, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: Line(posX1: x1, posY1: y1, posX2: x2, posY2: y2, text: text));
  }

  Connection copyWith({
    double? x1,
    double? y1,
    double? x2,
    double? y2,
    String? text,
  }) {
    return Connection(
      x1: x1 ?? this.x1,
      y1: y1 ?? this.y1,
      x2: x2 ?? this.x2,
      y2: y2 ?? this.y2,
      text: text ?? this.text,
    );
  }

  bool isInside(double dx, double dy) {
    double x = (x1 + x2) / 2;
    double y = (y1 + y2) / 2;
    return (dx - x).abs() < 15 && (dy - y).abs() < 15;
  }
}
