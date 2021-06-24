import 'package:flutter/material.dart';

import 'dart:math' as math;

class CustomParameter extends StatelessWidget{
  final int total;
  final int goal;
  double height;
  double width;
  Color backcolor;
  CustomParameter({
    this.total,
    this.goal,
    this.height,
    this.width,
    this.backcolor,
  });

  @override
  Widget build(BuildContext context) {
    if(height == null){
      height = 300;
    }
    if(width == null){
      width = 300;
    }
    if(backcolor == null){
      backcolor = Colors.blue;
    }

    final double parsent = total / goal;

    return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Container(
              color: Colors.blueAccent[100],
              height: height,
              width: width,
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
  Color backcolor;
  final double par;
  CirclePainter({
    this.backcolor,
    this.par,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if(backcolor == null){
      backcolor = Colors.blue;
    }


    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -60 * math.pi / 180;
    final sweepAngle = 300 * math.pi / 180;
    final paint = Paint()
      ..color = backcolor 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    final paint2 = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    final sweepAngle2 = 300 * math.pi / 180 * par;
    canvas.drawArc(rect, startAngle, sweepAngle2, false, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}