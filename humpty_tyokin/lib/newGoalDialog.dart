import 'package:flutter/material.dart';

import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';
import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/data/httpResponse.dart';
import 'package:humpty_tyokin/data/sqlite.dart';

class NewGoalDialog extends StatefulWidget {
  final int goal;
  NewGoalDialog({
    this.goal,
    Key key
  }) : super(key: key);

  @override
  _NewGoalDialogState createState() => _NewGoalDialogState();
}

class _NewGoalDialogState extends State<NewGoalDialog> {
  /** テキストコントローラ */
  var goalController = TextEditingController();
  /** フォーカス処理 */
  final _goalfocusNode = new FocusNode();
  /** エラーメッセージ */
  String errorMsg = "";

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    double textFieldHeight = 80;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
          child: Container(
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
                  children: [
                    Container(
                      height: deviceHeight * 0.9 * 0.2,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "前回の目標",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.9 * 0.1,
                      alignment: Alignment.center,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                        Icon(CotsumiIcons.group, color: Theme.of(context).accentColor,),
                        Text(widget.goal.toString(),
                          style: TextStyle(
                            fontSize: 30, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Theme.of(context).accentColor,
                          ),),
                      ],),
                    ),
                    Container(
                      height: deviceHeight * 0.9 * 0.2,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "新しい目標",
                        style: TextStyle(
                          fontSize: 30, color: Colors.black87
                        ),),
                    ),
                    Stack(children: [
                      Container(
                        alignment: Alignment.center,
                        height: textFieldHeight,
                        child: Column(
                          children: [
                            CustomTextField(
                              width: deviceWidth * 0.9 * 0.85,
                              height: 50,
                              labelText: "目標金額",
                              focusNode: _goalfocusNode,
                              controller: goalController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        )
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(errorMsg, style: TextStyle(color: Colors.redAccent, fontSize: 12),),),
                    ],),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 30),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        height: 35,
                        minWidth: 140,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 空白がなくなる
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        child: Text('貯めていく',style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                          /** 正規表現 */
                          bool flg = true;
                          setState(() => errorMsg = "");
                          if(!RegExp(r'^\d+$').hasMatch(goalController.text)){
                            setState(() => errorMsg = "数字だけを入力してください。");
                            flg = false;
                          }
                          /** OKだったら登録して次へ */
                          if(flg){
                            Goal _goal = Goal(goal: int.parse(goalController.text),);
                            await SQLite.insertGoal(_goal);
                            await HttpRes.remoteGoalsUpdate();
                            Navigator.of(context).pop();
                          }
                        },
                      )),
                  ],
                ),
              ])
            )
          )
        );
      })
    );
  }
}