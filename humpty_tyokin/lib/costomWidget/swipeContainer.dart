import 'package:flutter/material.dart';

class SwipeContainer extends StatefulWidget{
  final double height;
  final double width;
  double swipB;
  final Widget child;
  Color color;
  
  SwipeContainer({
    this.height = 500,
    this.width = null,
    this.swipB = 30,
    this.child = null,
    this.color,
  });
  @override
  SwipeContainerState createState() => SwipeContainerState();
}


class SwipeContainerState extends State<SwipeContainer> {
  double dyStart = 0.0;
  double dyMove = 0.0;
  @override
  Widget build(BuildContext context) {
    /** デフォルト値 */
    widget.color = widget.color == null ? Theme.of(context).accentColor : widget.color;
      /** ウィジェット */
      return AnimatedPositioned(
        duration: Duration(milliseconds: 200),
        bottom: -(widget.height - widget.swipB),
        child: GestureDetector(
          onVerticalDragStart: (DragStartDetails details){
            dyStart = details.globalPosition.dy;
          },
          onVerticalDragEnd: (details){
            setState(() {
              if(dyMove-dyStart < -10){ widget.swipB = widget.height - 20; }
              if(dyMove-dyStart >  10){ widget.swipB = 30; }
            });
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            dyMove = details.globalPosition.dy;
            print(details.globalPosition.dy);
            print(details.delta.dy);
            setState(() {
              widget.swipB = widget.height - details.globalPosition.dy;
            //   dyMove = details.globalPosition.dy;
            //   if (details.delta.dy < -10) { //上スワイプ
            //     widget.swipB = widget.height - 20; }
            //   if (details.delta.dy > 10) { //下スワイプ
            //     widget.swipB = 30; }
            });
          },
          /** スワイプコンテナ */
          child: Container(
            width: widget.width,
            height: widget.height + 20,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              Container(
                height: 50,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              widget.child,
            ]),
          ),
        ),
      );
  }
}