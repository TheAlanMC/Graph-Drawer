import 'package:flutter/material.dart';
import 'package:graph_drawer/widgets/graph.dart';

class Node extends StatelessWidget {
  final Color color;
  final double x;
  final double y;

  const Node({super.key, required this.color, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: Graph(color: color, posX: x, posY: y, radius: 50),
      ),
    );
  }
}
