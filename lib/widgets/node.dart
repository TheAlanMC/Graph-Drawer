import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/graph.dart';

class Node extends StatelessWidget {
  final Color color;
  final double x;
  final double y;
  final double radius;
  final String text;

  const Node({super.key, required this.color, required this.x, required this.y, required this.radius, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Graph(color: color, posX: x, posY: y, radius: radius, text: text),
    );
  }

  bool isInside(double dx, double dy) {
    return (dx - x).abs() < radius && (dy - y).abs() < radius;
  }
}
