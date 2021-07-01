import 'package:flutter/material.dart';

import 'dart:math' as math;

class CustomParameter extends StatelessWidget{
  double strokeWidth;
  int current;
  Color currentColor;
  int goal;
  Color goalColor;
  double height;
  double width;
  Color color;
  Color backcolor;
  CustomParameter({
    this.strokeWidth,
    this.current,
    this.currentColor,
    this.goal,
    this.goalColor,
    this.height,
    this.width,
    this.color,
    this.backcolor,
  });

  @override
  Widget build(BuildContext context) {
    if(strokeWidth == null){ strokeWidth = 28;}
    if(height == null){ height = 300;}
    if(width == null){ width = 300;}
    if(color == null){ color = Colors.blue;}
    if(backcolor == null){ backcolor = Colors.blueAccent[100];}
    currentColor = currentColor == null ? Colors.black : currentColor;
    goalColor = goalColor == null ? Colors.black : goalColor;

    final double parsent = current / goal;

    return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: CirclePainter(
              strokeWidth: this.strokeWidth,
              color: this.color,
              backcolor: this.backcolor,
              par: parsent),
          ),
          /** 数字類 */
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /** 貯金額 */
              Text(
                current.toString(),
                style: TextStyle(
                  color: this.currentColor,
                  fontSize: 60,
                  fontWeight: FontWeight.w200),
                ),
              /** アイコンと目標額 */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag,color: this.goalColor),
                  Text(goal.toString(),style: TextStyle(color: this.goalColor),)
                ],
              ),
            ],
          ),

        ]
    );
  }

}

class CirclePainter extends CustomPainter {
  double strokeWidth;
  Color color;
  Color backcolor;
  final double par;
  CirclePainter({
    this.strokeWidth,
    this.color,
    this.backcolor,
    this.par,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = this.backcolor 
      ..style = PaintingStyle.stroke
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
    final startAngle = -60 * math.pi / 180;
    final sweepAngle = 300 * math.pi / 180;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    paint = new Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweepAngle2 = 300 * math.pi / 180 * par;
    canvas.drawArc(rect, startAngle, sweepAngle2, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}