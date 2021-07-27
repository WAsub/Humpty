import 'package:flutter/material.dart';

class CustomCoinCount extends StatefulWidget {
  final double width;
  final int data;
  int count;
  final int max;
  Function(int, int) callback;

  CustomCoinCount({
    this.width,
    this.data = 500, 
    this.count = 0, 
    this.max = 10, 
    this.callback, 
    key}) : super(key: key);

  @override
  CustomCoinCountState createState() => CustomCoinCountState();
}

class CustomCoinCountState extends State<CustomCoinCount> {
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
          height: widgetWidth / 3,
          width: widgetWidth,
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: widgetWidth / 3,
                width: widgetWidth / 2,
                color: Theme.of(context).primaryColor,
                child: Text(
                  widget.data.toString(),
                  style: TextStyle(fontSize: 29.29),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: widgetWidth / 3,
                    width: widgetWidth / 2,
                    color: Colors.white,
                    child: Text(
                      widget.count.toString(),
                      style: TextStyle(fontSize: 29.29),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: widgetWidth / 3,
                        width: widgetWidth / 4,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).accentColor,),
                          onPressed: () {
                            setState(() {
                              if (widget.count > 0) {
                                widget.count--;
                              }
                            });
                            widget.callback(widget.data, widget.count);
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        height: widgetWidth / 3,
                        width: widgetWidth / 4,
                        child: IconButton(
                          icon: Icon(Icons.add_circle_outlined, color: Theme.of(context).accentColor,),
                          onPressed: () {
                            setState(() {
                              if (widget.count < widget.max) {
                                widget.count++;
                              }
                            });
                            widget.callback(widget.data, widget.count);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
