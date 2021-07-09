import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:humpty_tyokin/costomWidget/swipeContainer.dart';
import 'package:humpty_tyokin/data/sqlite.dart';
class WeeklyThokin extends StatefulWidget {
  double height;
  double width;
  StreamController streamC;
  DateTime weeklyNow;
  WeeklyThokin({
    this.height,
    this.width,
    this.streamC,
    this.weeklyNow,
    Key key
    }) : super(key: key);
  @override
  _WeeklyThokinState createState() => _WeeklyThokinState();
}

class _WeeklyThokinState extends State<WeeklyThokin> {
  DateFormat formatMD = DateFormat('M/d');
  
  @override
  Widget build(BuildContext context) {
    return SwipeContainer(
        height: widget.height,
        width: widget.width,
        swipB: 30,
        color: Theme.of(context).accentColor,
        child: StreamBuilder(
          // 指定したstreamにデータが流れてくると再描画される
          stream: widget.streamC.stream,
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            List<Thokin> list = snapShot.data;

            return Column(children: [
                /** 先週や来週へ */
                Container(
                  width: widget.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20,),
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        onPressed: () async {
                          widget.weeklyNow = widget.weeklyNow.add(Duration(days: -7));
                          List<Thokin> getweeklist = await SQLite.getWeeklyThokin(widget.weeklyNow);
                          widget.streamC.sink.add(getweeklist);
                        },
                      ),
                      Text(
                        formatMD.format(SQLite.getWeekStartEnd(widget.weeklyNow)[0]) + "〜" + formatMD.format(SQLite.getWeekStartEnd(widget.weeklyNow)[1]),
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 20,),
                        alignment: Alignment.centerRight,
                        color: Colors.white,
                        onPressed: () async {
                          widget.weeklyNow = widget.weeklyNow.add(Duration(days: 7));
                          List<Thokin> getweeklist = await SQLite.getWeeklyThokin(widget.weeklyNow);
                          widget.streamC.sink.add(getweeklist);
                        },
                      )
                    ],
                  ),
                ),
                /** 週間履歴 */
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white,),),
                  width: widget.width * 0.9,
                  height: widget.height * 0.7,
                  child: snapShot.hasData 
                  ? ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        TextStyle style1 = TextStyle(color: Colors.white, fontSize: 16,);
                        TextStyle style2 = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
                                        
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(list[index].money > 0 ? "収入" : "支出", style: style1),
                              Text("\¥" + list[index].money.toString(), style: style2),
                              Text(formatMD.format(list[index].date).toString(), style: style1),
                            ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(height: 5,),
                    ) 
                  : Container()
                ),
            ],);
          }
        ),
    );
  }
}
