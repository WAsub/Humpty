import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import '../data/httpResponse.dart';
import 'package:humpty_display/costomWidget/enterCoinCount.dart';
import 'package:humpty_display/data/sqlite.dart';

import '../costomWidget/numericKeypad.dart';
import 'confirmation_d.dart';

class Deposit extends StatefulWidget {
  final int total;
  Deposit({
    this.total,
    Key key
  }) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  double deviceHeight;
  double deviceWidth;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();
  
  /** ローディング処理 */
  Future<void> loading() async {
    /** データをセット */
    
  }

  @override
  void initState() {
    /** 一度だけロードする */
    memoizer.runOnce(() async => loading());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white,body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return Column(children: [
                Container(
                  height: deviceHeight * 0.8,
                  child: Stack(alignment: Alignment.topLeft, children: [
                        IconButton(
                          padding: EdgeInsets.only(top: 30, left: 10),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            HttpRes.sendDepositFlg(null);
                            Navigator.pop(context,"");
                          },
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: deviceHeight * 0.8,
                          child: Text("お金を入れて下さい。"),
                        ),
                      ]),
                ),
                
            Container(
              color: Colors.white,
              height: deviceHeight * 0.2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      child: Text(
                        "確認",
                        style: TextStyle(fontSize: 41.425),
                      ),
                      onPressed: () async {
                        int money = await HttpRes.getDepositMoney();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // ログイン画面へ
                            return ConfirmationD(money: money, total: widget.total,);
                          }),
                        ).then((value) async {
                          if(value == "return"){
                            Navigator.pop(context,"return");
                          }
                        });
                      }),
                ],
              ),
            )
          ]);
        })));
  }
}
