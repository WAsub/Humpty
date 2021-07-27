import 'package:flutter/material.dart';
import "dart:async";

class NumericKeypad extends StatefulWidget {
  double axisSpacing;
  Function(String) callback;
  NumericKeypad({
    Key key,
    this.axisSpacing,
    this.callback
  }) : super(key: key);

  @override
  NumericKeypadState createState() => NumericKeypadState();
}
class NumericKeypadState extends State<NumericKeypad> {
  /** キーアイテム */
  final List<Text> keyItem = [
    Text("7", style: TextStyle(fontSize: 29.29),),
    Text("8", style: TextStyle(fontSize: 29.29),),
    Text("9", style: TextStyle(fontSize: 29.29),),
    Text("4", style: TextStyle(fontSize: 29.29),),
    Text("5", style: TextStyle(fontSize: 29.29),),
    Text("6", style: TextStyle(fontSize: 29.29),),
    Text("1", style: TextStyle(fontSize: 29.29),),
    Text("2", style: TextStyle(fontSize: 29.29),),
    Text("3", style: TextStyle(fontSize: 29.29),),
    Text("0", style: TextStyle(fontSize: 29.29),),
    Text("C", style: TextStyle(color: Colors.white, fontSize: 29.29),),
  ];
  /** 列の数(固定値) */
  final int crossAxisCount = 3;
  /** グリッドアイテムの大きさ */
  double gredSize;
  /** アイテムのPosition */
  List<Offset> fixedPosition = [];

  @override
  Widget build(BuildContext context) {
    widget.axisSpacing = widget.axisSpacing == null ? 20.0 : widget.axisSpacing;

    return LayoutBuilder(builder: (context, constraints) {
      gredSize = (constraints.maxWidth - widget.axisSpacing * (crossAxisCount - 1)) / crossAxisCount;
      
      /** 各アイテムのPositionを設定 */
      fixedPosition = [];
      for (int index = 0; index < keyItem.length; index++) {
        fixedPosition.add(Offset(
          (index % crossAxisCount * gredSize) + index % crossAxisCount * widget.axisSpacing, 
          (index ~/ crossAxisCount * gredSize) + index ~/ crossAxisCount * widget.axisSpacing
        ));
      }
      /** グリッドビュー */
      return Container(
          child: Stack(
            children: List.generate(keyItem.length, (index) {
              return Positioned(
                top: fixedPosition[index].dy,
                left: fixedPosition[index].dx,
                child: GestureDetector(
                  onTap: (){
                    widget.callback(keyItem[index].data);
                  },
                  /** アイテム */
                  child: Container(
                    alignment: Alignment.center,
                    width: index == keyItem.length-1 ? gredSize*2+widget.axisSpacing : gredSize, 
                    height: gredSize, 
                    decoration: BoxDecoration(
                      color: index == keyItem.length-1 ? Theme.of(context).primaryColor : Colors.white,
                      border: index == keyItem.length-1 ? null : Border.all(width: 1.0),
                      boxShadow: [BoxShadow(
                        color: Colors.black12, 
                        blurRadius: 2.0, 
                        spreadRadius: 1.0, 
                        offset: Offset(1, 3))
                      ]
                    ),
                    child: keyItem[index]),
                )
              );
            }),
          ),
      );
    });
  }
}