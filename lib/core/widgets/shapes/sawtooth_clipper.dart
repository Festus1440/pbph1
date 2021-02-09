import 'dart:ui';

import 'package:flutter/material.dart';

class SawtoothClipper extends CustomClipper<Path> {
  const SawtoothClipper();

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    final parts = 15;
    final widthPerTriangle = size.width / parts;
    final heightPerTriangle = size.height * 0.95;
    for (int i = 0; i < parts; i++) {
      double width = path.getBounds().width;
      path.lineTo((widthPerTriangle / 2) + width, heightPerTriangle);
      width = path.getBounds().width;
      path.lineTo((widthPerTriangle / 2) + width, size.height);
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

