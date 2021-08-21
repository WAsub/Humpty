import 'package:flutter/material.dart';

import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/data/httpResponse.dart';
import 'package:humpty_tyokin/signUp/InitialGoal.dart';

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
                      style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w500)
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
                      style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 14,fontWeight: FontWeight.w500)
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
                        child: Text(errorMsg1, style: Theme.of(context).textTheme.subtitle2),),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 40 * nonMargin + 70),
                        child: Text(errorMsg2, style: Theme.of(context).textTheme.subtitle2),)
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: ((deviceHeight- textFieldHeight) * 0.4 - 30),
                    margin: EdgeInsets.only(top: 30),
                    child: TextButton(
                      child: Text('貯金額設定'),
                      onPressed: () async {
                        /** 正規表現 */
                        bool flg = true;
                        setState(() => errorMsg1 = "");
                        setState(() => errorMsg2 = "");
                        if(!RegExp(r'^[0-9a-zA-Zぁ-んァ-ヴ]{1,20}$').hasMatch(nameController.text)){
                          setState(() => errorMsg1 = "名前は半角英数,全角ひらがなカタカナ20字までです。");
                          flg = false;
                        }
                        if(!RegExp(r'^[0-9a-zA-Z]{6}$').hasMatch(passController.text)){
                          setState(() => errorMsg2 = "パスワードは半角英数6字です。");
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