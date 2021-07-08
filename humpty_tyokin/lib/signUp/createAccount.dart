import 'package:flutter/material.dart';

import 'package:humpty_tyokin/signUp/initialSetting.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}
class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    BoxDecoration backColor = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.1, 0.4, 0.8,],
        colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor, Colors.white,],
      ),
    );

    return  WillPopScope(
      /** 戻るボタンで戻れなくする */
      onWillPop: ()async=> false,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return Container(
            height: deviceHeight,
            width: deviceWidth,
            decoration: backColor,
            child: Column(
              children: [
                /** アイコン */
                Container(
                  alignment: Alignment.bottomCenter,
                  height: deviceHeight*0.5,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Image.asset('images/cotsumirogoTrim.png',width: 200,),
                ),
                Container(
                  alignment: Alignment.center,
                  height: deviceHeight*0.2,
                  child: Text("お金管理アプリ\n\n\n\n私たちと貯金を始めましょう！",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500, 
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    height: 35,
                    minWidth: 140,
                    child: Text('設定を行う',style: TextStyle(color: Theme.of(context).accentColor),),
                    color: Colors.white,
                    shape: StadiumBorder(),
                    onPressed: () {
                      Navigator .of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // アカウント設定へ
                          return InitialSetting();}),
                      ).then((value) async{
                        /** メイン画面まで戻す */
                        Navigator.pop(context,);
                      });
                    },
                  ),
                )
              ],
            ),
          );
        })
      )
    );
  }
}