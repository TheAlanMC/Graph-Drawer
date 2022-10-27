import 'package:flutter/material.dart';

class Line extends CustomPainter {
  final double posX1;
  final double posY1;
  final double posX2;
  final double posY2;
  final String text;

  Line(
      {required this.posX1,
      required this.posY1,
      required this.posX2,
      required this.posY2,
      required this.text}); // <== This is the problem

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Paint border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(posX1, posY1)
      ..lineTo(posX2, posY2)
      ..close();

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
    textPainter.layout();
    textPainter.paint(canvas, Offset(posX1 - 20, posY1 - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
