import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:humpty_sumple_gesturedetector/sample_icons.dart';

void main() => runApp(MyApp());

// MyAppウィジェットクラス
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

// MyHomePageウィジェットクラス
class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// MyHomePageステートクラス
class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset(10, -120); //Panドラッグ時のポジション
  double y = -70;

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    return Scaffold(
      appBar: AppBar(
        // title: Text("GestureDetector"),
        title: Text("サンプル"),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
        ),
      ),
      // body: LayoutBuilder(
      //   builder: (context, constraints) {
      //     deviceHeight = constraints.maxHeight;
      //     deviceWidth = constraints.maxWidth;
      //     debugPrint(deviceWidth.toString());
      //     return Stack(
      //       alignment: AlignmentDirectional.center,
      //       children: <Widget>[
      //         Container(
      //           color: Colors.black26,
      //           height: deviceHeight,
      //           width: deviceWidth,
      //           alignment: Alignment.center,
      //           child: Container(
      //             color: Colors.white,
      //             height: 300,
      //             width: 300,
      //             child: CustomPaint(
      //               size: Size(deviceWidth, deviceHeight),
      //               painter: CirclePainter(par: 0.4),
      //             ),
      //           ),
      //         ),

      //         // Panテスト用のウィジェット
      //         AnimatedPositioned(
      //           duration: Duration(milliseconds: 200),
      //           top: deviceHeight + y,
      //           child: GestureDetector(
      //             onVerticalDragUpdate: (DragUpdateDetails details) {
      //               print('onVerticalDragUpdate - ${details.toString()}');
      //               // details.globalPosition; //グローバル座標
      //               // details.localPosition; //ローカル座標
      //               // details.delta; //前回からの移動量
      //               setState(() {
      //                 if (details.delta.dy < -10) {
      //                   debugPrint('OK');
      //                   var dy = deviceHeight / 5 * 4;
      //                   y = dy - dy - dy;
      //                 }
      //                 if (details.delta.dy > 10) {
      //                   debugPrint('++');
      //                   y = -70;
      //                 }
      //               });
      //             },
      //             child: Container(
      //               color: Colors.green,
      //               width: deviceWidth,
      //               height: deviceHeight / 5 * 4,
      //               child: Center(
      //                 child: Text(''),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           color: Colors.red,
      //           child: Icon(Sample.aaa_1),
      //         )
      //       ],
      //     );
      //   },
      // )
    );
  }
}

class CirclePainter extends CustomPainter {
  final double par;
  CirclePainter({
    required this.par,
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
