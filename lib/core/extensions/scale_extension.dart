import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:responsive_flutter/scaling_query.dart';

extension ScaleExtension on BuildContext {
  ScalingQuery get responsiveFlutter => ResponsiveFlutter.of(this);
  double moderateScale(double size, [double factor = 0.5]) => responsiveFlutter.moderateScale(size, factor);
  double verticalScale(double size) => responsiveFlutter.verticalScale(size);
  double scale(double size) => responsiveFlutter.scale(size);
  double fontSize(double size) => responsiveFlutter.fontSize(size);
}