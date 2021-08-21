import 'package:flutter/material.dart';

import 'package:humpty_tyokin/data/sqlite.dart';

// ignore: must_be_immutable
class CoinCounter extends StatelessWidget{
  List<Thokin> thokinData = [];
  final Color color;
  Map<String,int> list = {"1": 0, "5": 0, "10": 0, "50": 0, "100": 0, "500": 0};
  List<Widget> widgetsL = [];
  List<Widget> widgetsR = [];
  TextStyle style1;
  TextStyle style2;
  double height;
  double width;
  CoinCounter({
    this.thokinData,
    this.color,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    style1 = style1 == null ? Theme.of(context).textTheme.headline4 : style1;
    style2 = style2 == null ? Theme.of(context).textTheme.overline : style2;
    /** データを加工 */
    for(int i = 0; i < thokinData.length; i++){
      list["1"] += thokinData[i].one_yen;
      list["5"] += thokinData[i].five_yen;
      list["10"] += thokinData[i].ten_yen;
      list["50"] += thokinData[i].fifty_yen;
      list["100"] += thokinData[i].hundred_yen;
      list["500"] += thokinData[i].five_hundred_yen;
    }
    /** ウィジェットリスト */
    for (var key in list.keys) {
      widgetsL.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(key, style: style1,),Text("円玉", style: style2,),
          ]
        ),
      );
      widgetsR.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(list[key].toString(), style: style1,),Text("マイ", style: style2,),
          ]
        ),
      );
    }
      /** ウィジェット */
      return Container(
        alignment: Alignment.center,
          color: Color(0xddffffff),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:  widgetsL
              ),
              Container(
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:  widgetsR
                ),
              ),
            ],
          )
      );
  }
}
