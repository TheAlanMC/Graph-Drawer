import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/node.dart';

class NodeModel extends StatelessWidget {
  final Color color;
  final double x;
  final double y;
  final double radius;
  final String text;

  const NodeModel({super.key, required this.color, required this.x, required this.y, required this.radius, required this.text});

  bool isInside(double dx, double dy) {
    return (dx - x).abs() < radius && (dy - y).abs() < radius;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Node(color: color, posX: x, posY: y, radius: radius, text: text),
    );
  }

  NodeModel copyWith({
    Color? color,
    double? x,
    double? y,
    double? radius,
    String? text,
  }) {
    return NodeModel(
      color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
      radius: radius ?? this.radius,
      text: text ?? this.text,
    );
  }
}
