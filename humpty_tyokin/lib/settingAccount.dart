import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:humpty_tyokin/costomWidget/cotsumiGoalCard.dart';
import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/cotsumiDrawer.dart';
import 'package:humpty_tyokin/sqlite.dart';

class SettingAccount extends StatefulWidget {
  const SettingAccount({Key key}) : super(key: key);

  @override
  _SettingAccountState createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  /** テキストコントローラ */
  var nameController = TextEditingController();
  var goalController = TextEditingController();
  /** フォーカス処理 */
  final _namefocusNode = new FocusNode();
  final _goalfocusNode = new FocusNode();
  /** 非表示用 */
  double nonShow = 1;
  double nonMargin = 0;
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
    _goalfocusNode.addListener(() {
      if (_goalfocusNode.hasFocus) {
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
    goalController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    double textFieldHeight = 150;

    return Scaffold(
      appBar: AppBar(
        title: Text('こつみ cotsumi'),
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context,);
        },),
      ),
      /******************************************************* AppBar*/
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
            child: Container(
              color: Colors.transparent,
              child: Column(
              children: [
                Container(
                  height: 50 * nonShow,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "アカウント設定",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  height: 100 * nonShow,
                  alignment: Alignment.bottomCenter,
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
                          hintText: "目標金額",
                          focusNode: _goalfocusNode,
                          controller: goalController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    )
                  ),
                  Container(height: 50 * nonShow,),
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
                      child: Text('変更を保存',style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        /** 正規表現 */
                        bool flg = true;
                        if(!RegExp(r'^[0-9a-zA-Z]{6,10}$').hasMatch(nameController.text)){
                          print(nameController);
                          flg = false;
                        }
                        if(!RegExp(r'^[0-9]{1,10}$').hasMatch(goalController.text)){
                          print(goalController);
                          flg = false;
                        }
                        /** OKだったら登録して次へ */
                        // if(flg){
                        //   // signUp(nameController.text,passController.text);
                        //   /** 次へ */
                        //   // Navigator.of(context).push(
                        //   //   MaterialPageRoute(builder: (context) {
                        //   //     // 目標設定へ
                        //   //     return InitialGoal();}),
                        //   // ).then((value) async{
                        //   //   /** メイン画面まで戻す */
                        //   //   Navigator.pop(context,);
                        //   // });
                        // }
                      },
                    )),
              ],
            ),
        )
        );
      }),
    );
  }
}
