import 'package:flutter/material.dart';
import 'package:humpty_tyokin/costomWidget/cotsumiGoalCard.dart';
import 'package:humpty_tyokin/cotsumiDrawer.dart';

class GoalHistory extends StatefulWidget {
  const GoalHistory({Key key}) : super(key: key);

  @override
  _GoalHistoryState createState() => _GoalHistoryState();
}

class _GoalHistoryState extends State<GoalHistory> {
  double deviceHeight;
  double deviceWidth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('こつみ cotsumi'),
      ),
      /******************************************************* AppBar*/
      drawer: CotsumiDrawer(),
      /******************************************************* Drawer*/
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;
        return Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Text(
                "目標達成履歴",
                style: TextStyle(fontSize: 18),
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CotsumiGoalCard();
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 11.68,
                    );
                  },
                )),
          ],
        );
      }),
    );
  }
}
