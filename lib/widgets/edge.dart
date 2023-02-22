import 'package:flutter/material.dart';
import 'dart:math' as math;

class Edge extends CustomPainter {
  final double posX1;
  final double posY1;
  final double posX2;
  final double posY2;
  final String text;
  final double radius;

  Edge({required this.posX1, required this.posY1, required this.posX2, required this.posY2, required this.text, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint arrow = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final angle = math.atan2(posY2 - posY1, posX2 - posX1);
    const arrowSize = 20;
    const arrowAngle = 25 * math.pi / 180;

    final arrowPath = Path()
      ..moveTo(posX2 - arrowSize * math.cos(angle - arrowAngle), posY2 - arrowSize * math.sin(angle - arrowAngle))
      ..lineTo(posX2, posY2)
      ..lineTo(posX2 - arrowSize * math.cos(angle + arrowAngle), posY2 - arrowSize * math.sin(angle + arrowAngle))
      ..close();

    canvas.drawPath(arrowPath, arrow);

    final Paint edge = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final edgePath = Path()
      ..moveTo(posX1, posY1)
      ..lineTo(posX2, posY2)
      ..close();

    canvas.drawPath(edgePath, edge);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset((posX1 + posX2) / 2 - 20, (posY1 + posY2) / 2 - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
