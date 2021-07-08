import 'package:flutter/material.dart';
import 'package:humpty_tyokin/data/sqlite.dart';

import 'coinCounter.dart';


class SwipeCoinCounter extends StatefulWidget{
  double height;
  double width;
  double swipL;
  List<Thokin> thokinData = [];
  Color color;
  
  SwipeCoinCounter({
    this.thokinData,
    this.height,
    this.width,
    this.swipL,
    this.color,
  });
  @override
  SwipeCoinCounterState createState() => SwipeCoinCounterState();
}


class SwipeCoinCounterState extends State<SwipeCoinCounter> {
  @override
  Widget build(BuildContext context) {
    // widget.height = widget.height == null ? 500.0 : widget.height;
    // widget.width = widget.width == null ? null : widget.width;
    widget.swipL = widget.swipL == null ? 0.0 : widget.swipL;
    widget.color = widget.color == null ? Theme.of(context).accentColor : widget.color;

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