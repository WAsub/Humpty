import 'package:flutter/material.dart';
import 'package:humpty_tyokin/data/httpResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/signUp/InitialGoal.dart';
import 'package:humpty_tyokin/apiResults.dart';

class InitialSetting extends StatefulWidget {
  @override
  _InitialSettingState createState() => _InitialSettingState();
}

class _InitialSettingState extends State<InitialSetting> {
  /** テキストコントローラ */
  var nameController = TextEditingController();
  var passController = TextEditingController();
  /** フォーカス処理 */
  final _namefocusNode = FocusNode();
  final _passfocusNode = FocusNode();
  /** 非表示用 */
  double nonShow = 1;
  double nonMargin = 0;
  /** エラーメッセージ */
  String errorMsg1 = "";
  String errorMsg2 = "";
  @override
  void initState() {
    super.initState();
    /** キーボードが出た時の処理を書く */
    _namefocusNode.addListener(() {
      if (_namefocusNode.hasFocus) {
        setState(() {
          nonShow = 0;
          nonMargin = 1;
        });
      } else {
        setState(() {
          nonShow = 1;
          nonMargin = 0;
        });
      }
    });
    _passfocusNode.addListener(() {
      if (_passfocusNode.hasFocus) {
        print('フォーカスした');
        setState(() {
          nonShow = 0;
          nonMargin = 1;
        });
      } else {
        print('フォーカスが外れた');
        setState(() {
          nonShow = 1;
          nonMargin = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    double textFieldHeight = 150;
    BoxDecoration backColor = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.1, 0.4, 0.8,],
        colors: [Colors.white, Theme.of(context).primaryColor, Theme.of(context).accentColor,],
      ),
    );
    

    return  WillPopScope(
      onWillPop: ()async=> false,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              decoration: backColor,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: (deviceHeight - textFieldHeight) * 0.2 * nonShow,
                    child: Text("アカウント設定",
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
                    child: Image.asset('images/cotsumirogoTrim.png',width: 100,),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: (deviceHeight - textFieldHeight) * 0.1 * nonShow,
                    child: Text("ニックネームとパスワードを\n設定してください",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500, 
                        fontSize: 14,
                      ),
                    )
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: textFieldHeight,
                        margin:  EdgeInsets.only(top: 40 * nonMargin),
                        child: Column(
                          children: [
                            CustomTextField(
                              width: deviceWidth * 0.85,
                              height: 50,
                              hintText: "ニックネーム",
                              focusNode: _namefocusNode,
                              controller: nameController,
                              keyboardType: TextInputType.name,
                            ),
                            CustomTextField(
                              width: deviceWidth * 0.85,
                              height: 50,
                              hintText: "パスワード",
                              focusNode: _passfocusNode,
                              controller: passController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ],
                        )
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 40 * nonMargin),
                        child: Text(errorMsg1, style: TextStyle(color: Colors.redAccent, fontSize: 12),),),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 40 * nonMargin + 70),
                        child: Text(errorMsg2, style: TextStyle(color: Colors.redAccent, fontSize: 12),),)
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: ((deviceHeight- textFieldHeight) * 0.4 - 30),
                    margin: EdgeInsets.only(top: 30),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      height: 35,
                      minWidth: 140,
                      child: Text('貯金額設定',style: TextStyle(color: Theme.of(context).accentColor),),
                      color: Colors.white,
                      shape: StadiumBorder(),
                      onPressed: () async {
                        /** 正規表現 */
                        bool flg = true;
                        setState(() => errorMsg1 = "");
                        setState(() => errorMsg2 = "");
                        if(!RegExp(r'^[0-9a-zA-Zぁ-んァ-ヴ]{1,20}$').hasMatch(nameController.text)){
                          // print(nameController);
                          setState(() => errorMsg1 = "名前は半角英数,全角ひらがなカタカナ20字までです。");
                          print(errorMsg1);
                          flg = false;
                        }
                        if(!RegExp(r'^[0-9a-zA-Z]{6}$').hasMatch(passController.text)){
                          // print(passController);
                          setState(() => errorMsg2 = "パスワードは半角英数6字です。");
                          print(errorMsg2);
                          flg = false;
                        }
                        /** OKだったら登録して次へ */
                        if(flg){
                          HttpRes.signUp(nameController.text,passController.text);
                          /** 次へ */
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // 目標設定へ
                              return InitialGoal();}),
                          ).then((value) async{
                            /** メイン画面まで戻す */
                            Navigator.pop(context,);
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          );
        })
      )
    );
  }
}