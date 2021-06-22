import 'package:flutter/material.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetting extends StatefulWidget {
  @override
  _InitialSettingState createState() => _InitialSettingState();
}

class _InitialSettingState extends State<InitialSetting> {
  /** HTTP通信 */
  ApiResults httpRes;
  var nameController = TextEditingController();
  var passController = TextEditingController();
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

    return  WillPopScope(
      onWillPop: ()async=> false,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  color: Color(0xff85b103),
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight*0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("アカウント設定",
                            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),),
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.yellowAccent,
                            ),
                            Text("ニックネームとパスワードを\n設定してください",
                            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                      Container(
                        height: deviceHeight*0.25,
                        child: Column(
                          children: [
                            Container(
                              width: deviceWidth * 0.85,
                              height: 50,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),),
                              child:TextField(
                                controller: nameController,
                                decoration: new InputDecoration(
                                  prefixText: "ニックネーム",
                                  prefixStyle: TextStyle(fontSize: 17,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide()
                                  ),
                                ),
                                style: TextStyle(fontSize: deviceHeight * 0.04,),
                                cursorColor: Colors.white,
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            Container(
                              width: deviceWidth * 0.85,
                              height: 50,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),),
                              child:TextField(
                                controller: passController,
                                decoration: new InputDecoration(
                                  prefixText: "パスワード",
                                  hintText: "パスワード",
                                  prefixStyle: TextStyle(fontSize: 17,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide()
                                  ),
                                ),
                                style: TextStyle(fontSize: deviceHeight * 0.04,),
                                cursorColor: Colors.white,
                                textAlign: TextAlign.right,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                          ],
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: FlatButton(
                          child: Text('貯金額設定',style: TextStyle(color: Color(0xff85b103)),),
                          color: Colors.white,
                          shape: StadiumBorder(),
                          onPressed: () {
                            bool flg = true;
                            if(!RegExp(r'^[0-9a-zA-Z]{6,10}$').hasMatch(nameController.text)){
                              print(nameController);
                              flg = false;
                            }
                            if(!RegExp(r'^[0-9a-zA-Z]{6,10}$').hasMatch(passController.text)){
                              print(passController);
                              flg = false;
                            }
                            if(flg){
                              signUp(nameController.text,passController.text);
                              Navigator .of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  // 初期設定へ
                                  return InitialSetting();}),
                              ).then((value) async{
                                // reload();
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
          
          
          
        })
      )
    );
  }
  
  /** 登録 */
  Future<void> signUp(String name, String pass) async {
    // memoizer.runOnce(
    //   () async {
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
