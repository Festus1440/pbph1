import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vector_math/vector_math_64.dart' as _vector hide Colors;
import 'dart:ui';
import 'package:rxdart/rxdart.dart';
import 'package:pb_ph1/core/extensions/scale_extension.dart';

typedef SlidingButtonEndCallback = void Function();

class SlidingButton extends HookWidget {
  final SlidingButtonEndCallback onSlideEnd;
  final BehaviorSubject<bool> _clickStream = BehaviorSubject<bool>();
  final String hint;
  SlidingButton({this.onSlideEnd, this.hint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dragState = useState(Offset.zero);
    useEffect(() {
      StreamSubscription _clickStreamSubscription =
          _clickStream.debounceTime(Duration(milliseconds: 350)).listen((event) {
            debugPrint('event $event');
        if (onSlideEnd != null) {
          onSlideEnd();
          dragState.value = Offset.zero;
        }
      }, onDone: () {
            debugPrint('onDone');
          }, onError: (e) {
            debugPrint('error $e');
          });

      return () {
        debugPrint('cancel subscription');
        _clickStreamSubscription?.cancel();
      };
    }, [_clickStream]);

    return Center(
      child: GestureDetector(
          child: CustomPaint(
            size: Size(context.screenWidth, context.moderateScale(80)),
            painter: SlidingButtonPainter(
                hint: this.hint,
                slidingButtonEndCallback: () {
                  _clickStream.add(true);
                },
                dragDetails: dragState.value,
                thumbColor: theme.primaryColor,
                thumbPathEraserColor: Scaffold.of(context)?.widget?.backgroundColor ?? theme.scaffoldBackgroundColor,
                textStyle: theme.textTheme.bodyText2.copyWith(color: theme.primaryColor, fontSize: context.moderateScale(13))),
          ),
          onHorizontalDragUpdate: (details) {
            final diff = dragState.value - details.localPosition;
            // debugPrint('dragDiff ${diff.distance}');
            if (diff.distance <= 100) {
              dragState.value = details.localPosition;
            }
          },
          onHorizontalDragEnd: (details) {
            dragState.value = Offset.zero;
          },
          onTapUp: (details) {
            dragState.value = Offset.zero;
          }),
    ).pSymmetric(h: context.moderateScale(10));
  }
}

class SlidingButtonPainter extends CustomPainter {
  final double minProgress;
  final double maxProgress;
  final Color thumbColor;
  final Color chevronColor;
  final Color trackColor;
  final String hint;
  final TextStyle textStyle;
  final Offset dragDetails;
  final Color thumbPathEraserColor;
  final SlidingButtonEndCallback slidingButtonEndCallback;

  SlidingButtonPainter(
      {this.dragDetails,
      this.thumbPathEraserColor = Colors.transparent,
      this.slidingButtonEndCallback,
      this.minProgress = 0.40,
      this.maxProgress = 0.90,
      this.thumbColor = Colors.blueAccent,
      this.chevronColor = Colors.white,
      this.trackColor = Colors.grey,
      this.hint = 'SLIDE TO CONFIRM',
      this.textStyle = const TextStyle(
        color: Colors.blue,
        fontSize: 10,
        letterSpacing: -0.5,
        fontWeight: FontWeight.bold,
      )});

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Paint chevronPaint = Paint()
      ..color = chevronColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Paint thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Paint thumbPathPaint = Paint()
      ..color = thumbPathEraserColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.70;

    final width = size.width;
    final height = size.height;

    final rectText = Rect.fromCenter(center: Offset(width / 2, height / 2), height: height, width: width / 2);

    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        text: TextSpan(style: textStyle, text: hint),
        maxLines: 3,
        ellipsis: '...')
      ..layout(maxWidth: rectText.width - 5);

    textPainter.paint(
        canvas, Offset(rectText.center.dx - (textPainter.width / 2), rectText.center.dy - (textPainter.height / 2)));

    final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height * 0.80),
        Radius.circular(size.height / 2));

    final Path rRectPath = Path()..addRRect(roundedRect);
    final progress = dragDetails.dx / width;
    final interpolatedProgress =
        lerpDouble(height * minProgress, width - (height * minProgress), progress < 0 ? 0.0 : progress > 1 ? 1.0 : progress);

    final rectCircle =
        Rect.fromCircle(center: Offset(interpolatedProgress, height / 2), radius: height * 0.35);
    final Path circlePath = Path()..addOval(rectCircle);

    circlePath.close();

    canvas.drawLine(Offset(height * minProgress, height / 2), circlePath.getBounds().center, thumbPathPaint);
    canvas.drawPath(circlePath, thumbPaint);

    canvas.save();
    final line = circlePath.getBounds().size.height * 0.30;
    canvas.translate(interpolatedProgress - (line / 4), circlePath.getBounds().size.height * 0.90);
    canvas.rotate(_vector.radians(225));
    canvas.drawLine(Offset.zero, Offset(0.0, line), chevronPaint);
    canvas.drawLine(Offset(0.0, line), Offset(line, line), chevronPaint);
    canvas.restore();

    rRectPath.close();
    canvas.drawPath(rRectPath, trackPaint);
    if (progress >= 1.0 && slidingButtonEndCallback != null) {
      slidingButtonEndCallback();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final painter = (oldDelegate as SlidingButtonPainter);
    return painter.thumbColor != thumbColor ||
        painter.chevronColor != chevronColor ||
        painter.minProgress != minProgress ||
        painter.maxProgress != maxProgress ||
        painter.hint != hint ||
        painter.trackColor != trackColor ||
        painter.dragDetails.dx != dragDetails.dx ||
        painter.thumbPathEraserColor != thumbPathEraserColor;
  }
}
