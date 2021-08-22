import 'package:flutter/material.dart';

import 'package:humpty_tyokin/newGoalDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutDialog extends StatefulWidget {
  @override
  _SignOutDialogState createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {

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
                height: deviceHeight * 0.5,
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
                      Image.asset('images/cotsumirogoTrim.png',width: 100,),
                      Text("サインアウトしますか？",
                        style: TextStyle(
                          fontSize: 30, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Colors.black45,
                        ),),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 30),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          height: 35,
                          minWidth: 140,
                          child: Text(
                            'サインアウト',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString("myid", "");
                            await prefs.setString("myname", "");
                            await prefs.setString("mypass", "");
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