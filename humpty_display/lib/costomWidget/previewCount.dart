import 'package:flutter/material.dart';

class PreviewCount extends StatefulWidget {
  final double width;
  final int data;
  final int count;
  Function(int, int) callback;

  PreviewCount({
    this.width,
    this.data = 500, 
    this.count = 0, 
    this.callback, 
    key}) : super(key: key);

  @override
  PreviewCountState createState() => PreviewCountState();
}

class PreviewCountState extends State<PreviewCount> {
  // double widgetHeight;
  double widgetWidth;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      widgetWidth = widget.width;
      if(widget.width == null){
        widgetWidth = constraints.maxWidth;
      }

      return Container(
        alignment: Alignment.center,
        child: Container(
          // color: Colors.blue,
          height: widgetWidth * 0.35,
          width: widgetWidth,
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: widgetWidth * 0.35,
                width: widgetWidth * 0.55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme.of(context).accentColor)
                ),
                child: Text(
                  widget.data.toString(),
                  style: TextStyle(fontSize: 29.29),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                height: widgetWidth * 0.35,
                width: widgetWidth * 0.45,
                child: Text(
                  "×"+widget.count.toString(),
                  style: TextStyle(fontSize: 25.3),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
