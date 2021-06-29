// import 'package:flutter/material.dart';

// import 'dart:math' as math;

// import 'package:humpty_tyokin/sqlite.dart';

// class CoinCounter extends StatelessWidget{
//   List<Thokin> thokinData = [];
//   CoinCounter({
    
//   });

//   @override
//   Widget build(BuildContext context) {
    

//     return ListView.separated(
//         itemCount: _thokinData.length,
//         itemBuilder: (context, index) {


//     });
    
//   }

// }

// class CirclePainter extends CustomPainter {
//   double strokeWidth;
//   Color color;
//   Color backcolor;
//   final double par;
//   CirclePainter({
//     this.strokeWidth,
//     this.color,
//     this.backcolor,
//     this.par,
//   });
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = this.backcolor 
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = this.strokeWidth
//       ..strokeCap = StrokeCap.round;
//     final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
//     final startAngle = -60 * math.pi / 180;
//     final sweepAngle = 300 * math.pi / 180;
//     canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

//     paint = new Paint()
//       ..color = this.color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = this.strokeWidth
//       ..strokeCap = StrokeCap.round;
//     final sweepAngle2 = 300 * math.pi / 180 * par;
//     canvas.drawArc(rect, startAngle, sweepAngle2, false, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }