import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:humpty_tyokin/costomWidget/cotsumiGoalCard.dart';
import 'package:humpty_tyokin/costomWidget/customTextField.dart';
import 'package:humpty_tyokin/cotsumiDrawer.dart';
import 'package:humpty_tyokin/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingAccount extends StatefulWidget {
  String myname;
  int goal;
  SettingAccount({
    this.myname,
    this.goal,
    Key key
  }) : super(key: key);

  @override
  _SettingAccountState createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  /** HTTP通信 */
  ApiResults httpRes;
  /** テキストコントローラ */
  var nameController = TextEditingController();
  var goalController = TextEditingController();
  /** フォーカス処理 */
  final _namefocusNode = new FocusNode();
  final _goalfocusNode = new FocusNode();
  /** 非表示用 */
  double nonShow = 1;
  double nonMargin = 0;
  /** エラーメッセージ */
  String errorMsg1 = "";
  String errorMsg2 = "";

  @override
  void initState() {
    super.initState();
    /** 今の名前と目標金額をセット */
    nameController = TextEditingController(text: widget.myname);
    goalController = TextEditingController(text: widget.goal.toString());
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
                Stack(children: [
                  Container(
                    alignment: Alignment.center,
                    height: textFieldHeight,
                    margin:  EdgeInsets.only(top: 40 * nonMargin),
                    child: Column(
                      children: [
                        CustomTextField(
                          width: deviceWidth * 0.85,
                          height: 50,
                          labelText: "ニックネーム",
                          focusNode: _namefocusNode,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                        ),
                        CustomTextField(
                          width: deviceWidth * 0.85,
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
                    margin: EdgeInsets.only(top: 40 * nonMargin),
                    child: Text(errorMsg1, style: TextStyle(color: Colors.redAccent, fontSize: 12),),),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 40 * nonMargin + 70),
                    child: Text(errorMsg2, style: TextStyle(color: Colors.redAccent, fontSize: 12),),)
                ],),
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
                    onPressed: () async {
                      /** 正規表現 */
                      bool flg = true;
                      setState(() => errorMsg1 = "");
                      setState(() => errorMsg2 = "");
                      if(!RegExp(r'^[0-9a-zA-Zぁ-んァ-ヴ]{1,20}$').hasMatch(nameController.text)){
                        // print(nameController);
                        setState(() => errorMsg1 = "名前は半角英数,全角ひらがなカタカナ20字までです。");
                        flg = false;
                      }
                      if(!RegExp(r'^\d+$').hasMatch(goalController.text)){
                        // print(goalController);
                        setState(() => errorMsg2 = "数字だけを入力してください。");
                        flg = false;
                      }
                      /** OKだったら登録して次へ */
                      if(flg){
                        if(widget.myname != nameController.text){
                          /** 前と違うものなら修正 */
                          await chengeName(nameController.text);
                        }
                        if(widget.goal != int.parse(goalController.text)){
                          /** 前と違うものなら修正 */
                          
                        }
                        /** 戻る */
                        Navigator.pop(context,);
                      }
                    },
                  )),
              ],
            ),
        )
        );
      }),
    );
  }

  /** 登録 */
  Future<void> chengeName(String name) async {
    bool flg = false;
    while (!flg) {
      // TODO API完成まではここの処理はコメントアウト
      /** サーバーへデータを送信 */
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new chengeNameRequest(username: name,).toJson()
      );
      /** 成功したら端末に保存 */
      if(httpRes.message != "Failed"){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("myname", name);
        flg = true;
      }
    }
  }
  /** 登録 */
  Future<void> goalSet(int goal) async {
    /** ローカルに保存 */
    Goal _goal = Goal(goal: goal,);
    await SQLite.insertGoal(_goal);
    /** さっき登録したIDを引き出して */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myId = (prefs.getString('myid') ?? "");
    /** 目標リスト引き出してIDを穴埋め */
    List<Goal> list = await SQLite.getGoal();
    for(int i = 0; i < list.length; i++){
      list[i].userId = myId;
    }
    print(list);
    // TODO API完成まではここの処理はコメントアウト
    /** サーバーへ登録 */
    // bool flg = false;
    // while (!flg) {
    //   /** サーバーへデータを送信 */
    //   httpRes = await fetchApiResults(
    //     "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
    //     new GoalUpdateRequest(goallist: list).toJson()
    //   );
    //   /** 成功したら端末に保存 */
    //   if(httpRes.message != "Failed"){
    //     flg = true;
    //   }
    // }
  }

}
class chengeNameRequest {
  final String username;
  chengeNameRequest({
    this.username,
  });
  Map<String, dynamic> toJson() => {
    'username': username,
  };
}