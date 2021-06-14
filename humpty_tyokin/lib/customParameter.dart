import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

Widget CustomParameter(double par, double height, double width){
  return Container(
                                  height: height,
                                  width: width,
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    child: CustomPaint(
                                      size: Size(width, height),
                                      painter: CirclePainter(par: par),
                                    ),
                                  ),
                                );
}

class CirclePainter extends CustomPainter {
  final double par;
  CirclePainter({
    this.par,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(20, 20, 280, 280);
    final startAngle = -60 * math.pi / 180;
    final sweepAngle = 300 * math.pi / 180;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

    final paint2 = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    final sweepAngle2 = 300 * math.pi / 180 * par;
    canvas.drawArc(rect, startAngle, sweepAngle2, useCenter, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}