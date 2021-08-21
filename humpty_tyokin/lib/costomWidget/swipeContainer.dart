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
  bool flg = null;
  @override
  Widget build(BuildContext context) {
    /** デフォルト値 */
    widget.color = widget.color == null ? Theme.of(context).accentColor : widget.color;

      /** ウィジェット */
      return AnimatedPositioned(
        duration: Duration(milliseconds: 120),
        bottom: -(widget.height - widget.swipB),
        child: GestureDetector(
          onVerticalDragStart: (DragStartDetails details){
            /** スタート位置を指定 */
            dyStart = details.globalPosition.dy;
            /** 上スワイプか下スワイプか */
            flg = widget.swipB == 30 ? true : false;
          },
          onVerticalDragEnd: (details){
            setState(() {
              /** 上スワイプ または 下スワイプが十分じゃない時 */
              if( (flg && dyMove-dyStart <= -50) || (!flg &&  dyMove-dyStart < 50) ){ 
                widget.swipB = widget.height - 20; 
              }
              /** 下スワイプ または 上スワイプが十分じゃない時 */
              if( (!flg && dyMove-dyStart >=  50) || (flg && dyMove-dyStart > -50 ) ){ 
                widget.swipB = 30; 
              }
            });
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            dyMove = details.globalPosition.dy;
            //                                  上スワイプ                下スワイプ 
            setState(() => widget.swipB = flg ? 30 + (dyStart-dyMove) : widget.height - 20 + (dyStart-dyMove) );
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