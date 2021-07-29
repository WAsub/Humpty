import 'package:flutter/material.dart';

import 'package:humpty_tyokin/costomWidget/coinCounter.dart';
import 'package:humpty_tyokin/data/sqlite.dart';

class SwipeCoinCounter extends StatefulWidget{
  double height;
  double width;
  double swipL;
  List<Thokin> thokinData = [];
  Color color;
  
  SwipeCoinCounter({
    @required this.thokinData,
    @required this.height,
    @required this.width,
    this.swipL,
    this.color,
  });
  @override
  SwipeCoinCounterState createState() => SwipeCoinCounterState();
}


class SwipeCoinCounterState extends State<SwipeCoinCounter> {
  @override
  Widget build(BuildContext context) {
    /** デフォルト値 */
    widget.swipL = widget.swipL == null ? 0.0 : widget.swipL;
    widget.color = widget.color == null ? Theme.of(context).accentColor : widget.color;
      /** ウィジェット */
      return AnimatedPositioned(
        height: widget.height,
        width: widget.width,
        duration: Duration(milliseconds: 250),
        left: widget.swipL,
        /** スワイプコンテナ */
        child: CoinCounter(thokinData: widget.thokinData, color: widget.color)
      );
  }
}