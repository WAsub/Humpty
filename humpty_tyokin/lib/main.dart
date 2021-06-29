
import 'package:flutter/material.dart';
import 'theme/dynamic_theme.dart';
import 'dart:async';
import 'dart:convert';
import 'sqlite.dart';
import 'package:async/async.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'coutomWidget/customParameter.dart';
import 'coutomWidget/swipeContainer.dart';

import 'package:humpty_tyokin/createAccount.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          home: Cotsumi(),
        );
      },
    );
  }
}
class Cotsumi extends StatefulWidget {
  @override
  _CotsumiState createState() => _CotsumiState();
}

class _CotsumiState extends State<Cotsumi> {
  /** HTTP通信 */
  ApiResults httpRes;
  /** ローカルデータベースから抽出したデータ */
  List<Thokin> _thokinData = [];
  double swipB = 30;
  int total = 0;
  int goal = 1000;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer= AsyncMemoizer();
  /** 端末にデータを保存する奴 */
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    /** 初回起動時のアカウント作成 */
    // getlogin();
  }
  getlogin() async {
    final SharedPreferences prefs = await _prefs;
    // final int login = (prefs.getInt('MyAccount') ?? 0) + 1;
    final bool first = (prefs.getBool('first') ?? false);
    if(!first){
      Navigator .of(context).push(
        MaterialPageRoute(builder: (context) {
          // ログイン画面へ
          return CreateAccount();}),
      ).then((value) async{
        // reload();
      });
    }
  }

  /** 初期化処理 */
  Future<void> reload() async {
    memoizer.runOnce(
      () async {
        /** サーバーからデータを取得 */
        httpRes = await fetchApiResults(
          "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
          new SampleRequest(userid: "abc").toJson()
        );
        /** データを取得できたらローカルのデータを入れ替え */
        if(httpRes.message != "Failed"){
          List<Thokin> thokin=[];
          for(int i = 0; i < httpRes.data.length; i++){
            thokin.add(Thokin(
              date: httpRes.data[i]["datetime"],
              money: httpRes.data[i]["money"],
              one_yen: httpRes.data[i]['one_yen'],
              five_yen: httpRes.data[i]['five_yen'],
              ten_yen: httpRes.data[i]['ten_yen'],
              fifty_yen: httpRes.data[i]['fifty_yen'],
              hundred_yen: httpRes.data[i]['hundred_yen'],
              five_hundred_yen: httpRes.data[i]['five_hundred_yen'],
            ));
          }
          await SQLite.deleteThokin();
          // print(await SQLite.getThokin());
          await SQLite.insertThokin(thokin);
        }
        /** データを取得 */
        List<Thokin> getlist = [];
        getlist = await SQLite.getThokin();
        /** データをセット */
        setState(() {
          _thokinData = getlist;
          total = 0;
          for(int i = 0; i < _thokinData.length; i++){
            total +=_thokinData[i].money;
          }
        });
        await new Future.delayed(new Duration(milliseconds: 1000));
        print(httpRes.data);
        print(_thokinData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    List<Widget> leadingIcon = [
      Icon(Icons.radio_button_off),
      Icon(Icons.article_sharp),
      Icon(Icons.settings),
    ];
    List<Widget> titleText = [
      Text("user"),
      Text("お知らせ"),
      Text("アカウント設定"),
    ];
    // var onTap = [null, PastRecord(), SetLine(), SetTheme(), Config(),];
    return Scaffold(
          appBar: AppBar(
            title: Text('こつみ cotsumi'),
            actions: [
              IconButton(onPressed: () async{
                reload();
              }, 
              icon: Icon(Icons.autorenew_sharp)),
            ],
          ),
          /******************************************************* AppBar*/
          drawer: Drawer(
            child: ListView.builder(
              itemCount: leadingIcon.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Container(
                      // color: Colors.blue,
                      alignment: Alignment.bottomRight,
                      child: ListTile(
                        leading: leadingIcon[index], // 左のアイコン
                        title: titleText[index], // テキスト
                        onTap: () {},
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: leadingIcon[index], // 左のアイコン
                    title: titleText[index], // テキスト
                    onTap: () {},
                  );
                }
              },
            ),
          ),
          /******************************************************* Drawer*/
          body: LayoutBuilder(builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return Column(
              children: [
                Container(
                  height: 50,
                  // color: Colors.redAccent,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      // ignore: deprecated_member_use
                      FlatButton(
                        height: 29.124,
                        minWidth: 100,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 空白がなくなる
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.monetization_on_outlined, color: Colors.white),
                          Text(
                            "現在高",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ]),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        onPressed: () {
                        
                        },
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        height: 29.124,
                        minWidth: 100,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 空白がなくなる
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.monetization_on_outlined, color: Colors.white),
                          Text(
                            "現在高",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ]),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        onPressed: () {
                        
                        },
                      ),
                    ]
                  ),
                ),

                Container(
                    height: deviceHeight - 50,
                    alignment: Alignment.center,
                    // color: Colors.greenAccent,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      /** 貯金額と目標達成率 */
                      CustomParameter(
                            current: total, 
                            currentColor: Theme.of(context).accentColor,
                            goal: goal, 
                            goalColor: Theme.of(context).accentColor,
                            color: Theme.of(context).accentColor,
                            backcolor: Theme.of(context).primaryColor,
                            strokeWidth: 26,
                            height: deviceWidth * 0.8, 
                            width: deviceWidth * 0.8
                          ),
                      Container(
                        color: Color(0xddffffff),

                      ),
                      
                      /** 履歴画面(下スワイプ) */
                      SwipeContainer(
                        height: deviceHeight / 5 * 4,
                        width: deviceWidth,
                        swipB: 30,
                        color: Theme.of(context).accentColor,
                        child: /** 履歴 */
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white,),
                                    ),
                                    width: deviceWidth * 0.9,
                                    height: deviceHeight / 5 * 4 * 0.7,
                                    child: ListView.separated(
                                      itemCount: _thokinData.length,
                                      itemBuilder: (context, index) {
                                        DateFormat outputFormat = DateFormat('MM/dd');
                                        TextStyle style1 = TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        );
                                        TextStyle style2 = TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        );
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _thokinData[index].money > 0 ? "収入" : "支出",
                                                style: style1
                                              ),
                                              Text(
                                                "\¥"+_thokinData[index].money.toString(),
                                                style: style2
                                              ),
                                              Text(
                                                outputFormat.format(DateTime.parse(_thokinData[index].date)).toString(),
                                                style: style1
                                              ),
                                            ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          height: 5,
                                        );
                                      },
                                    )
                                  ),
                      ),
                      /** ロード */
                      FutureBuilder(
                        future: reload(),
                        builder: (context, snapshot) {
                          // 非同期処理未完了 = 通信中
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return Center();
                        },
                      ),
                    ])
                ),
              ],
            );
          }),
        );
  }
}


// class ApiResults {
//   final String message;
//   final List<dynamic> data;
//   ApiResults({
//     this.message,
//     this.data,
//   });
//   factory ApiResults.errorMsg(String msg) {
//     return ApiResults(message: msg, data: null);
//   }
//   factory ApiResults.fromJson(Map<String, dynamic> json) {
//     return ApiResults(message: json['message'], data: json['data']);
//   }
// }

// Future<ApiResults> fetchApiResults() async {
//   var url = "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php";
//   var request = new SampleRequest(userid: "abc");
//   final response = await http.post(url, body: json.encode(request.toJson()), headers: {"Content-Type": "application/json"});

//   if (response.statusCode == 200) {
//     return ApiResults.fromJson(json.decode(response.body));
//   } else {
//     return ApiResults.errorMsg("Failed");
//     // throw Exception('Failed');
//   }
// }

class SampleRequest {
  final String userid;
  SampleRequest({
    this.userid,
  });
  Map<String, dynamic> toJson() => {
        'userid': userid,
      };
}
