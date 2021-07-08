import 'package:flutter/material.dart';

import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:humpty_tyokin/data/httpResponse.dart';
import 'package:humpty_tyokin/data/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialGoal extends StatefulWidget {
  @override
  _InitialGoalState createState() => _InitialGoalState();
}

class _InitialGoalState extends State<InitialGoal> {
  /** テキストコントローラとフォーカス */
  var goalController = TextEditingController();
  final _goalfocusNode = FocusNode();
  /** キーボード出たときに調整する用 */
  double nonShow = 1;
  /** エラーメッセージ */
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    _goalfocusNode.addListener(() {
      if (_goalfocusNode.hasFocus) {
        setState(() {
          nonShow = 0;
        });
      } else {
        setState(() {
          nonShow = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    double textFieldHeight = 150;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
              child: Container(
                height: deviceHeight,
                width: deviceWidth,
                color: Theme.of(context).accentColor,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: (deviceHeight - textFieldHeight) * 0.2 * nonShow,
                      child: Text(
                        "アカウント設定",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: (deviceHeight - textFieldHeight) * 0.3 * nonShow,
                      child: Image.asset(
                        'images/cotsumirogoTrim.png',
                        width: 100,
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        height: (deviceHeight - textFieldHeight) * 0.1 * nonShow,
                        child: Text(
                          "目標金額を設定してください\n(未入力の場合、後から設定できます)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        )),
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          height: 150,
                          child: CustomTextField(
                            width: deviceWidth * 0.85,
                            height: 50,
                            margin: EdgeInsets.only(top: 60),
                            hintText: "目標金額",
                            focusNode: _goalfocusNode,
                            controller: goalController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            errorMsg,
                            style: TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: ((deviceHeight - textFieldHeight) * 0.4 - 30),
                      margin: EdgeInsets.only(top: 30),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        height: 35,
                        minWidth: 140,
                        child: Text(
                          '貯めていく',
                          style: TextStyle(color: Color(0xff85b103)),
                        ),
                        color: Colors.white,
                        shape: StadiumBorder(),
                        onPressed: () async {
                          bool flg = false;
                          setState(() => errorMsg = "");
                          /** 数字なら通す */
                          if (RegExp(r'^\d+$').hasMatch(goalController.text)) {
                            print(goalController);
                            /** ローカルに保存 */
                            Goal _goal = Goal(goal: int.parse(goalController.text),);
                            await SQLite.insertGoal(_goal);
                            HttpRes.remoteGoalsUpdate();
                            flg = true;
                          } else {
                            setState(() => errorMsg = "数字だけを入力してください。\n(何も入力しない場合はスキップします)");
                            flg = false;
                          }
                          /** 設定しない場合も通す */
                          if (goalController.text == "") {
                            flg = true;
                          }
                          if (flg) {
                            /** ここまで終わったらメイン画面に戻す */
                            Navigator.pop(
                              context,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ));
        })));
  }
}
