import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'cotsumi_icons_icons.dart';

class CotsumiGoalCard extends StatelessWidget {
  DateTime entryDate;
  DateTime achieveDate;
  int money;
  bool flg;
  CotsumiGoalCard({
    this.entryDate,
    this.achieveDate,
    this.money,
    this.flg,
  });

  @override
  Widget build(BuildContext context) {
    entryDate = entryDate == null ? DateTime.now() : entryDate;
    achieveDate = achieveDate == null ? DateTime.now() : achieveDate;
    money = money == null ? 0 : money;
    flg = flg == null ? false : flg;

    DateFormat format = DateFormat('MM/dd');

    String entryDateStr = format.format(entryDate);
    String achieveDateStr = format.format(achieveDate);
    double deviceWidth;

    return LayoutBuilder(builder: (context, constraints) {
      deviceWidth = constraints.maxWidth;

      return Container(
        height: 75,
        padding: EdgeInsets.all(8.7),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6.0675),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 121.35,
                  alignment: Alignment.center,
                  child: Text(
                    "〜",
                    style: TextStyle(fontSize: 17.4, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Color(0xffeaeea2)),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    entryDateStr,
                    style: TextStyle(fontSize: 22, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Color(0xffeaeea2)),
                  ),
                ),
                Container(
                  width: 121.35,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    achieveDateStr,
                    style: TextStyle(fontSize: 22, fontFamily: 'RobotoMono', fontStyle: FontStyle.italic, color: Color(0xffeaeea2)),
                  ),
                ),
              ],
            ),
            Container(
              width: deviceWidth - 121.35 - 57.6 - 17.4,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 13.59),
              child: Text(
                "¥" + money.toString(),
                style: TextStyle(fontSize: 22, color: Theme.of(context).accentColor),
              ),
            ),
            Stack(
              children: [
                flg
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        width: 57.6,
                        child: Icon(
                          CotsumiIcons.check,
                          size: 60,
                          color: Color(0xffeaeea2),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  width: 57.6,
                  child: Text(
                    flg ? "達成" : "未達成",
                    style: TextStyle(fontSize: 17.4, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
