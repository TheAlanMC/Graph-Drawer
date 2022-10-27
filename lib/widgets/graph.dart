import 'package:flutter/material.dart';

class Graph extends CustomPainter {
  final Color color;
  final double posX;
  final double posY;
  final double radius;
  final String text;

  Graph({required this.color, required this.posX, required this.posY, required this.radius, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(posX, posY), radius: radius))
      ..close();

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius - 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
    textPainter.layout();
    textPainter.paint(canvas, Offset(posX - radius / 4, posY - radius / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
