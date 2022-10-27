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
}
