import 'package:flutter/material.dart';

class DashLinePainter extends CustomPainter {
  const DashLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final parts = 60;
    final widthPerLine = size.width / parts;
    final spacing = widthPerLine;
    double startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    int i = 0;
    while (i < parts) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX + widthPerLine, size.height), paint);
      startX += widthPerLine + spacing;
      i++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}