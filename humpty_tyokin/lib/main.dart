import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:humpty_tyokin/signOutDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';
import 'package:humpty_tyokin/costomWidget/customParameter.dart';
import 'package:humpty_tyokin/costomWidget/swipeCoinCounter.dart';
import 'package:humpty_tyokin/data/httpResponse.dart';
import 'package:humpty_tyokin/data/sqlite.dart';
import 'package:humpty_tyokin/signUp/createAccount.dart';
import 'package:humpty_tyokin/theme/dynamic_theme.dart';
import 'package:humpty_tyokin/achieveDialog.dart';
import 'package:humpty_tyokin/goalHistory.dart';
import 'package:humpty_tyokin/settingAccount.dart';
import 'package:humpty_tyokin/weeklyThokin.dart';

import 'signIn/login.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//縦固定
  ]);
  runApp(MyApp());
}

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
  /// 初期化を一回だけするためのライブラリ
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /// リロード時のぐるぐる
  Widget cpi;
  /// ログインデータ
  List<String> _loginData = ["", "", ""];
  /// ローカルデータベースから抽出したデータ
  List<Thokin> _thokinData = [];
  int _total = 0;
  int _goal = 0;
  /// コイン枚数のスワイプ用
  double swip = 700;
  bool swipFlg = true;
  double dxStart = 0.0;
  double dxMove = 0.0;
  /// 週間貯金データ用
  // DateTime weeklyNowShow = DateTime.now();
  DateTime weeklyNowShow = DateTime.parse("2021-01-03 15:25:07"); //TODO テスト用
  DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat formatMD = DateFormat('M/d');
  /// 週間貯金データコンテナ部分生成用
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
    init();
    // /** 初回起動時のアカウント作成 */
    // isFirst();
    // /** ログインの有無 */
    // isLogin();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool first = (prefs.getBool('first') ?? false);
    final String myId = (prefs.getString("myid") ?? "");
    final String myAct = (prefs.getString("myname") ?? "");
    final String mypass = (prefs.getString("mypass") ?? "");
    if (!first) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          // チュートリアル画面へ
          return CreateAccount();
        }),
      ).then((value) async {
        /** リロード */
        isLogin();
        loading();
      });
    }else if (myAct != "" && mypass != "") {
      setState(() => _loginData = [myId, myAct, mypass]);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          // ログイン画面へ
          return Login();
        }),
      ).then((value) async {
        /** リロード */
        init();
        loading();
      });
    }
  }

  /** チュートリアルを出すか判定 */
  Future<void> isFirst() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool first = (prefs.getBool('first') ?? false);
    if (!first) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          // チュートリアル画面へ
          return CreateAccount();
        }),
      ).then((value) async {
        /** リロード */
        isLogin();
        loading();
      });
    }
  }

  /** ログイン */
  Future<void> isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myId = (prefs.getString("myid") ?? "");
    final String myAct = (prefs.getString("myname") ?? "");
    final String mypass = (prefs.getString("mypass") ?? "");
    if (myAct != "" && mypass != "") {
      setState(() => _loginData = [myId, myAct, mypass]);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          // ログイン画面へ
          return Login();
        }),
      );
    }
  }

  /** 目標達成しているか */
  Future<void> isAchieve() async {
    /** 目標達成していたらダイアログ表示 */
    if(_goal == 0){
      return;
    }else if(_total >= _goal){
      /** 目標達成登録 */
      await SQLite.achieveNowGoal(true);
      await HttpRes.remoteGoalsUpdate();
      /** ダイアログ表示 */
      await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AchieveDialog(goal: _goal,);
        }
      );
      await loading();
    }
  }

  /** ローディング処理 */
  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator(color: Theme.of(context).selectedRowColor,));
    /** サーバーからデータを取得してローカルのデータを入れ替え */
    HttpRes.getThokinData();
    /** データを取得 */
    // 貯金データ全部
    List<Thokin> getlist = await SQLite.getThokin();
    // 今の目標
    Goal nowgoal = await SQLite.getGoalNow();
    /** データをセット */
    setState(() {
      _thokinData = getlist;
      _total = 0;
      for (int i = 0; i < _thokinData.length; i++) {
        _total += _thokinData[i].money;
      }
      _goal = !nowgoal.flg ? nowgoal.goal : 0;
    });
    // 週間貯金データ(下のスワイプコンテナ用)
    /// setState(() => weeklyNowShow = DateTime.now());
    setState(() => weeklyNowShow = DateTime.parse("2021-01-03 15:25:07")); // TODO テスト用
    List<Thokin> getweeklist = await SQLite.getWeeklyThokin(weeklyNowShow);
    _streamController.sink.add(getweeklist); // StreamBuilderに流して部分生成
    /** 目標達成したか判定 */
    isAchieve();
    /** グルグル終わり */
    setState(() => cpi = null);
  }

  @override
  Widget build(BuildContext context) {
    /** Drawer */
    List<Widget> leadingIcon = [
      Image.asset('images/cotsumirogoTrim.png',width: 40,),
      Icon(CotsumiIcons.osiraseicon, color: Theme.of(context).primaryColor,),
      Icon(CotsumiIcons.accounticon, color: Theme.of(context).primaryColor,),
      Icon(CotsumiIcons.group, color: Theme.of(context).primaryColor,),
    ];
    List<Widget> titleText = [
      Text("  "+_loginData[1]),
      Text("お知らせ"),
      Text("アカウント設定"),
      Text("達成履歴"),
    ];
    var onTap = [
      "logout",
      null,
      SettingAccount(
        myid: _loginData[0],
        myname: _loginData[1],
        goal: _goal,
      ),
      GoalHistory(),
    ];
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
      drawer: Drawer(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: ListView.separated(
            itemCount: leadingIcon.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: leadingIcon[index], // 左のアイコン
                title: titleText[index], // テキスト
                onTap: () async {
                  if(onTap[index] == "logout"){
                    /** ダイアログ表示 */
                    await showDialog<int>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SignOutDialog();
                      }
                    ).then((value) async {
                      await init();
                    });
                  }else if (onTap[index] != null){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        // ログイン画面へ
                        return onTap[index];
                      }),
                    ).then((value) async {
                      await isLogin();
                      await loading();
                    });
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              if (index == 1) {
                return Container(
                  height: 30,
                  color: Theme.of(context).accentColor,
                );
              }
              return Container(
                height: 2,
              );
            },
          ),
        ),
      ),
      /******************************************************* Drawer*/
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

          return Column(children: [
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
                    current: _total, 
                    goal: _goal, 
                    height: deviceWidth * 0.8, 
                    width: deviceWidth * 0.8
                  ),
                  /** 硬貨の枚数 */
                  SwipeCoinCounter(
                    swipL: swip,
                    thokinData: _thokinData,
                    height: deviceHeight - 50,
                    width: deviceWidth,
                  ),
                  /** スワイプによる画面の切り替え */
                  Container(
                    /** 有効範囲を画面半分にして、切り替えごとに左右入れ替える */
                    alignment: swipFlg ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: deviceWidth / 2,
                      child: GestureDetector(
                        onTap: (){}, // 画面に触れただけで切り替えが始まらないように
                        onHorizontalDragStart: (DragStartDetails details) /** スタート位置を指定 */
                          => dxStart = details.globalPosition.dx,
                        onHorizontalDragEnd: (DragEndDetails details){
                          setState(() {
                            /** 左スワイプ または 右スワイプが十分じゃない時 */
                            if( (swipFlg && dxMove-dxStart <= -100) || (!swipFlg &&  dxMove-dxStart < 100) ){ 
                              swip = 0; 
                              swipFlg = false;
                            }
                            /** 右スワイプ または 左スワイプが十分じゃない時 */
                            if( (!swipFlg && dxMove-dxStart >=  100) || (swipFlg && dxMove-dxStart > -100 ) ){ 
                              swip = deviceWidth; 
                              swipFlg = true;
                            }
                          });
                        },
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          dxMove = details.globalPosition.dx;
                          /** 指の場所の座標を当てる */
                          setState(() => swip = dxMove);
                        },
                      ),
                    )
                  ),
                  /** スワイプさせられる矢印ボタン(画面によって左右変わる) */
                  swipFlg ? 
                    Container(
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
                    ) : 
                    Container(
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
                ])
            ),
          ]);
      }),
    );
  }
}