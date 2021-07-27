import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'deposit/deposit.dart';
import 'data/httpResponse.dart';
import 'data/sqlite.dart';
import 'theme/dynamic_theme.dart';
import 'withdrawal/withdrawal.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,//横固定
  ]);
  //runApp
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          home: CotsumiDisplay(),
        );
      },
    );
  }
}

class CotsumiDisplay extends StatefulWidget {
  CotsumiDisplay({Key key,}) : super(key: key);
  @override
  _CotsumiDisplayState createState() => _CotsumiDisplayState();
}

class _CotsumiDisplayState extends State<CotsumiDisplay> {
  double deviceHeight;
  double deviceWidth;
  /** リロード時のぐるぐる */
  Widget cpi;
  /** 貯金データ */
  List<Thokin> _thokinData = [];
  int total = 0;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();

  /** ローディング処理 */
  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator());
    /** サーバーからデータを取得してローカルのデータを入れ替え */
    HttpRes.getThokinData("acb");
    /** データを取得 */
    // 貯金データ全部
    List<Thokin> getlist = await SQLite.getThokin();
    /** データをセット */
    setState(() {
      _thokinData = getlist;
      total = 0;
      for (int i = 0; i < _thokinData.length; i++) {
        total += _thokinData[i].money;
      }
    });
    /** グルグル終わり */
    setState(() => cpi = null);
  }

  @override
  void initState() {
    /** 一度だけロードする */
    memoizer.runOnce(() async => loading());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:  LayoutBuilder(builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return Column(children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: deviceHeight * 0.2,
                child: Text("残高"),
              ),
              Container(
                alignment: Alignment.center,
                height: deviceHeight * 0.4,
                child: Container(
                  width: deviceWidth * 0.5,
                  height: deviceHeight * 0.4 * 0.5,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2.5))
                  ),
                  child: Stack(children: [
                    Container(
                      alignment: Alignment.bottomLeft, 
                      child: Text("¥", style: TextStyle(fontSize: 57.73),),
                    ),
                    Container(
                      alignment: Alignment.bottomRight, 
                      child: Text(total.toString(), style: TextStyle(fontSize: 57.73),),
                    )
                  ],),
                )
              ),
              Container(
                height: deviceHeight * 0.4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text("入金",),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                      onPressed: () {
                        HttpRes.sendDepositFlg(true);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // 入金画面へ
                            return Deposit(total: total,);
                          }),
                        );
                      }
                    ),
                    TextButton(
                      child: Text("出金",),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // 出金画面へ
                            return Withdrawal(thokinData: _thokinData, total: total,);
                          }),
                        );
                      }
                    )  
                  ],
                ),
              )
            ],);
        })
      )
    );
  }
}
