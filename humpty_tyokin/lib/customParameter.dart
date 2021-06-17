import 'package:flutter/material.dart';

import 'dart:math' as math;

class CustomParameter extends StatelessWidget{
  final int total;
  final int goal;
  final double height;
  final double width;
  CustomParameter({
    this.total,
    this.goal,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double parsent = total / goal;

    return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Container(
              height: 300,
              width: 300,
              child: CustomPaint(
                size: Size(width, height),
                painter: CirclePainter(par: parsent),
              ),
            ),
          ),
          /** 数字類 */
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /** 貯金額 */
              Text(
                total.toString(),
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w200),
                ),
              /** アイコンと目標額 */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag),
                  Text(goal.toString())
                ],
              ),
            ],
          ),

        ]
    );
  }

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