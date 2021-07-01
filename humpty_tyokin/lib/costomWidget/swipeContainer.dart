import 'package:flutter/material.dart';

class SwipeContainer extends StatefulWidget{
  double height;
  double width;
  double swipB;
  Widget child;
  Color color;
  
  SwipeContainer({
    this.height,
    this.width,
    this.swipB,
    this.child,
    this.color,
  });
  @override
  SwipeContainerState createState() => SwipeContainerState();
}


class SwipeContainerState extends State<SwipeContainer> {
  @override
  Widget build(BuildContext context) {
    widget.height = widget.height == null ? 500.0 : widget.height;
    widget.width = widget.width == null ? null : widget.width;
    widget.swipB = widget.swipB == null ? 30.0 : widget.swipB;
    widget.child = widget.child == null ? null : widget.child;
    widget.color = widget.color == null ? Colors.blue : widget.color;

    return AnimatedPositioned(
        duration: Duration(milliseconds: 200),
        bottom: -(widget.height - widget.swipB),
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              if (details.delta.dy < -10) { //上スワイプ
                widget.swipB = widget.height - 20; }
              if (details.delta.dy > 10) { //下スワイプ
                widget.swipB = 30; }
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