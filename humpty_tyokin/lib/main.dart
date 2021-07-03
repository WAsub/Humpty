
import 'package:flutter/material.dart';
import 'package:humpty_tyokin/costomWidget/coinCounter.dart';
import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';
import 'theme/dynamic_theme.dart';
import 'dart:async';
import 'dart:convert';
import 'sqlite.dart';
import 'package:async/async.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'costomWidget/customParameter.dart';
import 'costomWidget/swipeContainer.dart';

import 'package:humpty_tyokin/createAccount.dart';
import 'package:humpty_tyokin/apiResults.dart';
import 'package:intl/intl.dart';
import 'costomWidget/swipeCoinCounter.dart';
import 'kirikaeFlgs.dart';

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
  double deviceHeight;
  double deviceWidth;
  /** HTTP通信 */
  ApiResults httpRes;
  /** ローカルデータベースから抽出したデータ */
  List<Thokin> _thokinData = [];
  double swipB = 30;
  int total = 0;
  int goal = 0;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer= AsyncMemoizer();
  /** 端末にデータを保存する奴 */
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  /** リロード時のぐるぐる */
  Widget cpi;
  /** スワイプ用 */
  double swip = 700;
  bool swipFlg = true;

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
        setState(() {
          cpi = CircularProgressIndicator(color: Theme.of(context).selectedRowColor,);
        });
        await new Future.delayed(new Duration(milliseconds: 3000));
        print(cpi);
        /** サーバーからデータを取得 */
        httpRes = await fetchApiResults(
          "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
          new DataRequest(userid: "abc").toJson()
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
        List<Thokin> getlist = await SQLite.getThokin();
        Goal nowgoal = await SQLite.getGoalNow();
        /** データをセット */
        setState(() {
          _thokinData = getlist;
          total = 0;
          for(int i = 0; i < _thokinData.length; i++){
            total +=_thokinData[i].money;
          }
          goal = !nowgoal.flg ? nowgoal.goal : 0;
        });
        print(goal);
        setState(() {
          cpi = null;
        });
        // print(httpRes.data);
        // print(_thokinData);
        // print(cpi);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leadingIcon = [
      Icon(Icons.radio_button_off),
      Icon(CotsumiIcons.osiraseicon),
      Icon(CotsumiIcons.group),
      Icon(CotsumiIcons.group),
    ];
    List<Widget> titleText = [
      Text("user"),
      Text("お知らせ"),
      Text("アカウント設定"),
      Text("達成履歴"),
    ];
    memoizer.runOnce(() async {
      reload();
    },);
    // var onTap = [null, PastRecord(), SetLine(), SetTheme(), Config(),];
    return Scaffold(
          appBar: AppBar(
            title: Text('こつみ cotsumi'),
            actions: [
              // Container(alignment: Alignment.center,height: 15,color: Colors.red,child: CircularProgressIndicator(color: Theme.of(context).selectedRowColor,),),
              IconButton(onPressed: () async{
                reload();
                print("aaa");
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
                /** スワイプさせられるボタン(現在の画面を示すのも兼ねている) */
                Container(
                  height: 50,
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
                          Icon(CotsumiIcons.genzaidakaicon, color: !swipFlg ? Theme.of(context).accentColor : Colors.white),
                          Text(
                            "現在高",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: !swipFlg ? Theme.of(context).accentColor : Colors.white),
                          ),
                        ]),
                        color: swipFlg ? Theme.of(context).accentColor : null,
                        shape: StadiumBorder(),
                        onPressed: () {
                          setState(() {
                            swip = deviceWidth; 
                            swipFlg = true;
                          });
                        },
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        height: 29.124,
                        minWidth: 100,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 空白がなくなる
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(CotsumiIcons.coinsuuicon, color: swipFlg ? Theme.of(context).accentColor : Colors.white),
                          Text(
                            "硬貨数",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: swipFlg ? Theme.of(context).accentColor : Colors.white),
                          ),
                        ]),
                        color: !swipFlg ? Theme.of(context).accentColor : null,
                        shape: StadiumBorder(),
                        onPressed: () {
                          setState(() {
                            swip = 0; 
                            swipFlg = false;
                          });
                        },
                      ),
                    ]
                  ),
                ),
                /** 切り替わる画面 */
                Container(
                    height: deviceHeight - 50,
                    alignment: Alignment.center,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      /** 貯金額と目標達成率 */
                      CustomParameter(
                        current: total, 
                        currentColor: Theme.of(context).accentColor,
                        goal: goal, 
                        goalColor: Theme.of(context).primaryColor,
                        color: Theme.of(context).accentColor,
                        backcolor: Theme.of(context).primaryColor,
                        strokeWidth: 26,
                        height: deviceWidth * 0.8, 
                        width: deviceWidth * 0.8
                      ),
                      /** 硬貨の枚数 */
                      SwipeCoinCounter(
                        swipL: swip,
                        thokinData: _thokinData, 
                        color: Theme.of(context).accentColor,
                        height: deviceHeight - 50,
                        width: deviceWidth,
                      ),
                      /** スワイプによる画面の切り替え */
                      Container(
                        child: GestureDetector(
                          onHorizontalDragUpdate: (DragUpdateDetails details){
                            setState(() {
                              if (details.delta.dx > 10) { //右スワイプ
                                swip = deviceWidth; 
                                swipFlg = true;}
                              if (details.delta.dx < -10) { //左スワイプ
                                swip = 0; 
                                swipFlg = false;}
                            });
                          },
                        ),
                      ),
                      /** スワイプさせられる矢印ボタン(画面によって左右変わる) */
                      swipFlg ? 
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios), 
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              swip = 0; 
                              swipFlg = false;
                            });
                          },)
                      ) : 
                      Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios), 
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              swip = deviceWidth; 
                              swipFlg = true;
                            });
                          },)
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
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top:10),
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: 25,
                          height: 25,
                          child: cpi,
                        )
                      )
                    ])
                ),
              ],
            );
          }),
        );
  }
}
class DataRequest {
  final String userid;
  DataRequest({
    this.userid,
  });
  Map<String, dynamic> toJson() => {
        'userid': userid,
      };
}
