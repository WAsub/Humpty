import 'package:flutter/material.dart';

import 'package:humpty_tyokin/newGoalDialog.dart';

class AchieveDialog extends StatefulWidget {
  final int goal;
  AchieveDialog({
    this.goal,
    Key key
  }) : super(key: key);

  @override
  _AchieveDialogState createState() => _AchieveDialogState();
}

class _AchieveDialogState extends State<AchieveDialog> {

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    
    return Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: deviceHeight * 0.9,
                width: deviceWidth * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).accentColor,)
                ),
                child: Stack(alignment: Alignment.center,children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: deviceHeight * 0.9,
                    width: deviceWidth * 0.9,
                    child: IconButton(
                      icon:Icon(Icons.close, color: Theme.of(context).primaryColor, size: 30,),
                      onPressed: () => Navigator.of(context).pop(),)
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        Image.asset('images/tasseiphoto.png', width: 200,),
                        Text(widget.goal.toString(),
                        style: TextStyle(
                          fontSize: 40, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Colors.white,
                        ),),
                      ],),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 30),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          height: 35,
                          minWidth: 140,
                          child: Text(
                            '新しい目標をたてる',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          onPressed: () async {
                            await showDialog<int>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return NewGoalDialog(goal: widget.goal,);
                              }
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )
                ],)
              ),
            );
          })
        );
  }
}