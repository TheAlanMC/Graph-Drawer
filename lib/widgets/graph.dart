import 'package:flutter/material.dart';

class Graph extends CustomPainter {
  final Color color;
  final double posX;
  final double posY;
  final double radius;

  Graph({required this.color, required this.posX, required this.posY, required this.radius});

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
      text: const TextSpan(
        text: 'A',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
    textPainter.layout();
    textPainter.paint(canvas, Offset(posX - 10, posY - 15));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
