import 'package:flutter/material.dart';
import 'dart:async';
import 'sqlite.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:humpty_tyokin/theme/dynamic_theme.dart';
import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';
import 'package:humpty_tyokin/costomWidget/customParameter.dart';
import 'package:humpty_tyokin/costomWidget/swipeCoinCounter.dart';
import 'package:humpty_tyokin/cotsumiDrawer.dart';
import 'package:humpty_tyokin/weeklyThokin.dart';
import 'package:humpty_tyokin/createAccount.dart';
import 'package:humpty_tyokin/apiResults.dart';
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
  int total = 0;
  int goal = 0;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /** 端末にデータを保存する奴 */
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  /** リロード時のぐるぐる */
  Widget cpi;
  /** コイン枚数のスワイプ用 */
  double swip = 700;
  bool swipFlg = true;
  /** 週間貯金データ用 */
  // DateTime weeklyNowShow = DateTime.now();
  DateTime weeklyNowShow = DateTime.parse("2021-01-03 15:25:07"); //TODO テスト用
  DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat formatMD = DateFormat('M/d');
  /** 週間貯金データコンテナ部分生成用 */
  final _streamController = StreamController();

  @override
  void dispose() {
    // StreamControllerは必ず開放する
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    /** 初回起動時のアカウント作成 */
    // getlogin();
  }

  /** チュートリアルを出すか判定 */
  getlogin() async {
    final SharedPreferences prefs = await _prefs;
    // final int login = (prefs.getInt('MyAccount') ?? 0) + 1;
    final bool first = (prefs.getBool('first') ?? false);
    if (!first) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          // チュートリアル画面へ
          return CreateAccount();
        }),
      );
    }
  }

  /** ローディング処理 */
  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator());
    await new Future.delayed(new Duration(milliseconds: 3000));
    /** サーバーからデータを取得 */
    httpRes = await fetchApiResults(
      "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
      // new DataRequest(userid: "abc").toJson()
      new DataRequest(userid: "abc").toJson() // TODO　テスト用
    );
    /** データを取得できたらローカルのデータを入れ替え */
    if (httpRes.message != "Failed") {
      List<Thokin> thokin = [];
      for (int i = 0; i < httpRes.data.length; i++) {
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
      await SQLite.insertThokin(thokin);
    }
    /** データを取得 */
    // 貯金データ全部
    List<Thokin> getlist = await SQLite.getThokin();
    // 今の目標
    Goal nowgoal = await SQLite.getGoalNow();
    /** データをセット */
    setState(() {
      _thokinData = getlist;
      total = 0;
      for (int i = 0; i < _thokinData.length; i++) {
        total += _thokinData[i].money;
      }
      goal = !nowgoal.flg ? nowgoal.goal : 0;
    });
    // 週間貯金データ(下のスワイプコンテナ用)
    // setState(() => weeklyNowShow = DateTime.now());
    setState(() => weeklyNowShow = DateTime.parse("2021-01-03 15:25:07")); // TODO テスト用
    List<Thokin> getweeklist = await SQLite.getWeeklyThokin(weeklyNowShow);
    _streamController.sink.add(getweeklist); // StreamBuilderに流して部分生成
    /** グルグル終わり */ 
    setState(() => cpi = null);
    // print(httpRes.data);
    // print(_thokinData);
    // print(cpi);
  }

  @override
  Widget build(BuildContext context) {
    /** 一度だけロードする */
    memoizer.runOnce(() async => loading());
    /** 画面 */
    return Scaffold(
      appBar: AppBar(
        title: Text('こつみ cotsumi'),
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew_sharp),
            onPressed: () async => loading(),
          )
        ],
      ),
      /******************************************************* AppBar*/
      drawer: CotsumiDrawer(),
      /******************************************************* Drawer*/
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return Column( children: [
            /** スワイプさせられるボタン(現在の画面を示すのも兼ねている) */
            Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
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
              ]),
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
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          if (details.delta.dx > 10) {
                            //右スワイプ
                            swip = deviceWidth;
                            swipFlg = true;
                          }
                          if (details.delta.dx < -10) {
                            //左スワイプ
                            swip = 0;
                            swipFlg = false;
                          }
                        });
                      },
                    ),
                  ),
                  /** スワイプさせられる矢印ボタン(画面によって左右変わる) */
                  swipFlg
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            swip = 0;
                            swipFlg = false;
                          });
                        },
                      )
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            swip = deviceWidth;
                            swipFlg = true;
                          });
                        },
                      )
                    ),
                  /** 履歴画面(下スワイプ) */
                  // weeklyThokin.dart
                  WeeklyThokin(
                    height: deviceHeight / 5 * 4,
                    width: deviceWidth,
                    streamC: _streamController,
                    weeklyNow: weeklyNowShow,
                  ),
                  /** ロード */
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 25,
                      height: 25,
                      child: cpi,
                    )
                  )
                ]
              )
            ),
          ],
        );
      }),
    );
  }
}
class DataRequest {
  final String userid;
  DataRequest({this.userid,});
  Map<String, dynamic> toJson() => {
    'userid': userid,
  };
}
