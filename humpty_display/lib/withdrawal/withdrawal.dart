import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:humpty_display/costomWidget/customCoinCount.dart';
import 'package:humpty_display/costomWidget/enterCoinCount.dart';
import 'package:humpty_display/data/sqlite.dart';

import '../costomWidget/numericKeypad.dart';
import 'confirmation_w.dart';

class Withdrawal extends StatefulWidget {
  final List<Thokin> thokinData;
  final int total;
  Withdrawal({
    this.thokinData,
    this.total,
    Key key
  }) : super(key: key);

  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  double deviceHeight;
  double deviceWidth;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<int> coinMax = [0,0,0,0,0,0];
  int money = 0;
  Map<int,int> coinData;
  final _streamController = StreamController();
  /** ローディング処理 */
  Future<void> loading() async {
    /** データをセット */
    setState(() {
      coinMax = [0,0,0,0,0,0];
      for (int i = 0; i < widget.thokinData.length; i++) {
        coinMax[0] += widget.thokinData[i].five_hundred_yen;
        coinMax[1] += widget.thokinData[i].hundred_yen;
        coinMax[2] += widget.thokinData[i].fifty_yen;
        coinMax[3] += widget.thokinData[i].ten_yen;
        coinMax[4] += widget.thokinData[i].five_yen;
        coinMax[5] += widget.thokinData[i].one_yen;
      }
    });
  }
  @override
  void initState() {
    /** 一度だけロードする */
    memoizer.runOnce(() async => loading());
    super.initState();
  }
  @override
  void dispose() {
    // StreamControllerは必ず開放する
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _streamController.sink.add(0);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return Column(children: [
            Row(
              children: [
                Container(
                  color: Colors.white,
                  width: deviceWidth * 0.5,
                  child: Column(
                    children: [
                      Stack(alignment: Alignment.topLeft, children: [
                        IconButton(
                          padding: EdgeInsets.only(top: 30, left: 10),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {Navigator.pop(context,"");},
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
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text("¥", style: TextStyle(fontSize: 57.73),),
                              ),
                              StreamBuilder(
                                // 指定したstreamにデータが流れてくると再描画される
                                stream: _streamController.stream,
                                builder: (BuildContext context, AsyncSnapshot snapShot) {
                                  if(!snapShot.hasData){
                                    return Container();
                                  }
                                  return Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text( snapShot.data.toString(), style: TextStyle(fontSize: 57.73),),
                                  );
                              }),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth * 0.5,
                  height: deviceHeight * 0.8,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: deviceHeight * 0.8 * 0.25,
                        color: Colors.white,
                        child: Text(
                          "取り出す金額を入力してください。",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: deviceWidth * 0.45,
                        height: deviceHeight * 0.8 * 0.6,
                        child: EnterCoinCount(
                          maxData: coinMax,
                          callback: (data){
                            int m = 0;
                            for (var key in data.keys) {
                              print('$key : ${data[key]}');
                              m += key * data[key];
                            }
                            // setState(() {
                              _streamController.sink.add(m);
                              money = m;
                              coinData = data;
                            // });
                            print(data);
                          },
                        ),
                      )
                    ],
                  )
                ),
              ],
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
                      onPressed: () {
                        print(money);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // ログイン画面へ
                            return ConfirmationW(money: money, coinData: coinData, total: widget.total,);
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
