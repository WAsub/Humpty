import 'package:flutter/material.dart';

import '/data/sqlite.dart';

// ignore: must_be_immutable
class CoinCounter extends StatelessWidget{
  List<Thokin> thokinData = [];
  Color color = Colors.blue;
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
    color = color == null ? Colors.blue : color;
    style1 = style1 == null ? TextStyle(fontSize: 30,color: this.color) : style1;
    style2 = style2 == null ? TextStyle(fontSize: 15,color: this.color) : style2;
    for(int i = 0; i < thokinData.length; i++){
      list["1"] += thokinData[i].one_yen;
      list["5"] += thokinData[i].five_yen;
      list["10"] += thokinData[i].ten_yen;
      list["50"] += thokinData[i].fifty_yen;
      list["100"] += thokinData[i].hundred_yen;
      list["500"] += thokinData[i].five_hundred_yen;
    }
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
            Container(width: 130,
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
