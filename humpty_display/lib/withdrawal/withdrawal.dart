import 'package:flutter/material.dart';
import 'package:humpty_display/costomWidget/customCoinCount.dart';

import '../costomWidget/numericKeypad.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({ Key key }) : super(key: key);

  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  double deviceHeight;
  double deviceWidth;
  String money = "";
  callback(callback) async {
    print(callback);
    if(callback == "C"){
      setState(() => money = money.substring(0, money.length-1));
    }else{
      setState(() => money += callback);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body:  LayoutBuilder(builder: (context, constraints) {
              deviceHeight = constraints.maxHeight;
              deviceWidth = constraints.maxWidth;

              return Column(children: [
                Row(children: [
                  Container(
                    color: Colors.white,
                    width: deviceWidth * 0.6,
                      child: Column(children: [
                          Stack(alignment: Alignment.topLeft,children: [
                            IconButton(
                              padding: EdgeInsets.only(top: 30,left: 10),
                              icon: Icon(Icons.arrow_back, size: 50, color: Theme.of(context).accentColor,),
                              onPressed: (){}, 
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: deviceHeight * 0.2,
                              child: Text("出金金額"),
                            ),
                          ]),
                          Container(
                            alignment: Alignment.center,
                            height: deviceHeight * 0.6,
                            child: Container(
                              width: deviceWidth * 0.6 * 0.7,
                              height: deviceHeight * 0.4 * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(bottom: BorderSide(width: 2.5))
                              ),
                              child: Stack(children: [
                                Container(alignment: Alignment.bottomLeft, child: Text("¥", style: TextStyle(fontSize: 57.73),),),
                                Container(alignment: Alignment.bottomRight, child: Text(money, style: TextStyle(fontSize: 57.73),),)
                              ],),
                            )
                          ),
                      ],),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: deviceWidth * 0.4,
                    height: deviceHeight * 0.8,
                    color: Colors.white,
                    child: 
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("取り出す金額を入力してください。",
                        style: TextStyle(fontSize: 15),),
                      Container(
                        color: Colors.white,
                        width: deviceWidth * 0.4 * 0.6,
                        height: deviceWidth * 0.4 * 0.6 / 3.0 * 4.2,
                        // child: NumericKeypad(
                        //   callback: callback,
                        // ),
                        child: customCoinCount(),
                      )
                    ],)
                  ),
                ],),
                Container(
                  color: Colors.white,
                  height: deviceHeight * 0.2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text("枚数設定",style: TextStyle(fontSize: 41.425),),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // ログイン画面へ
                              return Withdrawal();
                            }),
                          );
                        }
                      ),
                    ],
                  ),
                )
              ]);

            })
          )
    );
  }
}