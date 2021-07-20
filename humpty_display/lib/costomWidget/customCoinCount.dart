import 'package:flutter/material.dart';

class customCoinCount extends StatefulWidget {
  int data;
  int count;
  customCoinCount({ 
    this.data,
    this.count,
    Key key 
  }) : super(key: key);

  @override
  _customCoinCountState createState() => _customCoinCountState();
}

class _customCoinCountState extends State<customCoinCount> {
  double widgetHeight;
  double widgetWidth;
  @override
  Widget build(BuildContext context) {
    widget.data = widget.data == null ? 500 : widget.data;
    widget.count = widget.count == null ? 0 : widget.count;
    return LayoutBuilder(builder: (context, constraints) {
      widgetHeight = constraints.maxHeight;
      widgetWidth = constraints.maxWidth;

      return Container(
        alignment: Alignment.center,
        child: Container(
          color: Colors.blue,
          height: widgetWidth/3,
          width: widgetWidth,
          child: Row(children: [
            Container(
              alignment: Alignment.center,
              height: widgetWidth/3,
              width: widgetWidth/2,
              color: Theme.of(context).primaryColor,
              child: Text(widget.data.toString(), style: TextStyle(fontSize: 29.29),),
            ),
            Stack(children: [
              Container(
                alignment: Alignment.center,
                height: widgetWidth/3,
                width: widgetWidth/2,
                color: Colors.white,
                child: Text(widget.count.toString(), style: TextStyle(fontSize: 29.29),),
              ),
              Row(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: widgetWidth/3,
                  width: widgetWidth/4,
                  color: Colors.blueAccent.withOpacity(0.5),
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.remove_circle_outline)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  height: widgetWidth/3,
                  width: widgetWidth/4,
                  color: Colors.indigoAccent.withOpacity(0.5),
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.add_circle_outlined)),
                ),
              ],)
            ],)
          ],),
        ),
      );
      

    });
  }
}