import 'package:flutter/material.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:humpty_tyokin/coutomWidget/customTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialGoal extends StatefulWidget {
  @override
  _InitialGoalState createState() => _InitialGoalState();
}

class _InitialGoalState extends State<InitialGoal> {
  /** HTTP通信 */
  ApiResults httpRes;
  var goalController = TextEditingController();

  final _goalfocusNode = FocusNode();

  double nonShow = 1;
  @override
  void initState() {
    super.initState();
    _goalfocusNode.addListener(() {
      if (_goalfocusNode.hasFocus) {
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
    goalController.dispose();
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
                    child: Text("目標金額を設定してください\n(未入力の場合、後から設定できます)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500, 
                        fontSize: 14,
                      ),
                    )
                  ),
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
                    height: ((deviceHeight- textFieldHeight) * 0.4 - 30),
                    margin: EdgeInsets.only(top: 30),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      height: 35,
                      minWidth: 140,
                      child: Text('貯めていく',style: TextStyle(color: Color(0xff85b103)),),
                      color: Colors.white,
                      shape: StadiumBorder(),
                      onPressed: () {
                        bool flg = true;
                        /** 数字なら通す */
                        if(!RegExp(r'^\d+$').hasMatch(goalController.text)){
                          print(goalController);
                          flg = false;
                        }
                        /** 設定しない場合も通す */
                        if(goalController.text == ""){
                          flg = true;
                        }
                        if(flg){
                          print("ddd");
                          // goalSet(int.parse(goalController.text));
                          /** ここまで終わったらメイン画面に戻す */
                          Navigator.pop(context,);
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
  Future<void> goalSet(int goal) async {
    // memoizer.runOnce(
    //   () async {
        // bool flg = false;
        // while (!flg) {
        //   /** サーバーへデータを送信 */
        //   httpRes = await fetchApiResults(
        //     "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        //     new SignUpRequest(username: name, userpass: pass).toJson()
        //   );
        //   /** 成功したら端末に保存 */
        //   if(httpRes.message != "Failed"){
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     await prefs.setString("myname", name);
        //     await prefs.setString("mypass", pass);
        //     await prefs.setBool("first", true);
        //     await prefs.setBool("login", true);
        //     flg = true;
        //   }
        // }
        
        
    //   },
    // );
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
