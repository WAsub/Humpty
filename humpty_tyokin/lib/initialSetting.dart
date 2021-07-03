import 'package:flutter/material.dart';
import 'package:humpty_tyokin/InitialGoal.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:humpty_tyokin/costomWidget/customTextField.dart';

class InitialSetting extends StatefulWidget {
  @override
  _InitialSettingState createState() => _InitialSettingState();
}

class _InitialSettingState extends State<InitialSetting> {
  /** HTTP通信 */
  ApiResults httpRes;
  /** テキストコントローラ */
  var nameController = TextEditingController();
  var passController = TextEditingController();
  /** フォーカス処理 */
  final _namefocusNode = FocusNode();
  final _passfocusNode = FocusNode();
  /** 非表示用 */
  double nonShow = 1;
  double nonMargin = 0;
  @override
  void initState() {
    super.initState();
    /** キーボードが出た時の処理を書く */
    _namefocusNode.addListener(() {
      if (_namefocusNode.hasFocus) {
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
    _passfocusNode.addListener(() {
      if (_passfocusNode.hasFocus) {
        print('フォーカスした');
        setState(() {
          nonShow = 0;
        });
      } else {
        print('フォーカスが外れた');
        setState(() {
          nonShow = 1;
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
              color: Color(0xff85b103),
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
                    child: Container(
                          height: 100,
                          width: 100,
                          color: Colors.yellowAccent,
                        ),
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
                    height: ((deviceHeight- textFieldHeight) * 0.4 - 30),
                    margin: EdgeInsets.only(top: 30),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      height: 35,
                      minWidth: 140,
                      child: Text('貯金額設定',style: TextStyle(color: Color(0xff85b103)),),
                      color: Colors.white,
                      shape: StadiumBorder(),
                      onPressed: () {
                        /** 正規表現 */
                        bool flg = true;
                        if(!RegExp(r'^[0-9a-zA-Z]{6,10}$').hasMatch(nameController.text)){
                          print(nameController);
                          flg = false;
                        }
                        if(!RegExp(r'^[0-9a-zA-Z]{6,10}$').hasMatch(passController.text)){
                          print(passController);
                          flg = false;
                        }
                        /** OKだったら登録して次へ */
                        if(flg){
                          // signUp(nameController.text,passController.text);
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
  
  /** 登録 */
  Future<void> signUp(String name, String pass) async {
        bool flg = false;
        while (!flg) {
          /** サーバーへデータを送信 */
          httpRes = await fetchApiResults(
            "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
            new SignUpRequest(username: name, userpass: pass).toJson()
          );
          /** 成功したら端末に保存 */
          if(httpRes.message != "Failed"){
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("myname", name);
            await prefs.setString("mypass", pass);
            await prefs.setBool("first", true);
            await prefs.setBool("login", true);
            flg = true;
          }
        }
  }

}

class SignUpRequest {
  final String username;
  final String userpass;
  SignUpRequest({
    this.username,
    this.userpass,
  });
  Map<String, dynamic> toJson() => {
    'username': username,
    'userpass': userpass,
  };
}
