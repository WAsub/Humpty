import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';

class CustomParameter extends StatelessWidget{
  final double strokeWidth;
  int current;
  Color currentColor;
  int goal;
  Color goalColor;
  final double height;
  final double width;
  Color color;
  Color backcolor;
  CustomParameter({
    this.strokeWidth = 26,
    this.current,
    this.currentColor,
    this.goal,
    this.goalColor,
    this.height = 300,
    this.width = 300,
    this.color,
    this.backcolor,
  });

  @override
  Widget build(BuildContext context) {
    /** デフォルトカラー */
    this.color = this.color == null ? Theme.of(context).accentColor : this.color;
    this.backcolor = this.backcolor == null ? Theme.of(context).primaryColor : this.backcolor;
    this.currentColor = this.currentColor == null ? Theme.of(context).accentColor : this.currentColor;
    this.goalColor = this.goalColor == null ? Theme.of(context).primaryColor : this.goalColor;
    /** 割合(未設定の場合0で割ることができないので1) */
    double parsent = goal == 0 ? 1 : current / goal;
      /** ウィジェット */
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: CirclePainter(
              strokeWidth: this.strokeWidth,
              color: this.color,
              backcolor: this.backcolor,
              par: parsent
            ),
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
                  Icon(CotsumiIcons.group,color: this.goalColor),
                  Text(goal == 0 ? "未設定" : goal.toString(), style: TextStyle(color: this.goalColor),)
                ],
              ),
            ],
          ),
          Container(
            height: this.height * 1.15,
            alignment: Alignment.topCenter,
            child: Icon(CotsumiIcons.dollicon,size: 55, color: this.color,),
          )
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