import 'package:flutter/material.dart';
import 'package:humpty_tyokin/initialSetting.dart';
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
        stops: [0.2, 0.7,],
        colors: [Color(0xff85b103), Colors.white,],
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
                  height: deviceHeight*0.5,
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.yellowAccent,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: deviceHeight*0.2,
                  child: Text("新しい貯金アプリ\n\n\n\n私たちと貯金を始めましょう！",
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
                    child: Text('設定を行う',style: TextStyle(color: Color(0xff85b103)),),
                    color: Colors.white,
                    shape: StadiumBorder(),
                    onPressed: () {
                      Navigator .of(context).push(
                        MaterialPageRoute(builder: (context) {
                           // 初期設定へ
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