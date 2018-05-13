import 'package:flutter/material.dart';
import 'dart:math';

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.timerColor,
  });

  final Animation<double> animation;
  final Color timerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    paint.color =
        timerColor; // the outline should be a different color than the circle

    double percent = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, percent, false,
        paint); // draws an arc around the circle given a Rect, start angle, sweepangle and whether or not the arc should close back to the center
  }

  @override
  bool shouldRepaint(TimerPainter oldTimer) => true;
}
