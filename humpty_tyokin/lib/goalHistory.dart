import 'package:flutter/material.dart';
import 'package:async/async.dart';

import 'package:humpty_tyokin/costomWidget/cotsumiGoalCard.dart';
import 'package:humpty_tyokin/data/sqlite.dart';
class GoalHistory extends StatefulWidget {
  const GoalHistory({Key key}) : super(key: key);

  @override
  _GoalHistoryState createState() => _GoalHistoryState();
}

class _GoalHistoryState extends State<GoalHistory> {
  double deviceHeight;
  double deviceWidth;

  List<Goal> _goaldata = [];
  /** リロード時のぐるぐる */
  Widget cpi;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();

  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator());
    /** データを取得 */
    List<Goal> getlist = await SQLite.getGoal();
    /** データをセット */
    setState(() => _goaldata = getlist);
    /** グルグル終わり */ 
    setState(() => cpi = null);
  }

  @override
  Widget build(BuildContext context) {
    /** 一度だけロードする */
    memoizer.runOnce(() async => loading());
    /** 画面 */
    return Scaffold(
      appBar: AppBar(
        title: Text('こつみ cotsumi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,),
        ),
      ),
      /******************************************************* AppBar*/
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;
        return Stack(children: [
            Column(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "目標達成履歴",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                ),
                Container(
                    width: deviceWidth * 0.9,
                    height: deviceHeight - 100,
                    child: ListView.separated(
                      itemCount: _goaldata.length,
                      itemBuilder: (context, index) {
                        if(!_goaldata[index].flg){
                          return null;
                        }
                        return CotsumiGoalCard(
                          entryDate: _goaldata[index].entryDate,
                          achieveDate: _goaldata[index].achieveDate,
                          money: _goaldata[index].goal,
                          flg: _goaldata[index].flg,
                        );
                      },
                      // itemCount: 10,
                      // itemBuilder: (context, index) {
                      //   return CotsumiGoalCard(flg: true,); //TODO テスト用
                      // },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 11.68,
                        );
                      },
                    )),
              ],
            ),
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
        ]);
      }),
    );
  }
}
