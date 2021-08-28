import 'package:flutter/material.dart';
import 'package:humpty_display/data/httpResponse.dart';

class ConfirmationD extends StatefulWidget {
  final int money;
  final int total;
  ConfirmationD({
    this.money,
    this.total,
    Key key
  }) : super(key: key);

  @override
  _ConfirmationDState createState() => _ConfirmationDState();
}

class _ConfirmationDState extends State<ConfirmationD> {
  double deviceHeight;
  double deviceWidth;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white, body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return Column(children: [
            Stack(alignment: Alignment.topLeft, children: [
              IconButton(
                padding: EdgeInsets.only(top: 30, left: 10),
                icon: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {Navigator.pop(context,"");},
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: deviceHeight * 0.15,
                child: Text("入金確認"),
              ),
            ]),
            Container(
              alignment: Alignment.center,
              height: deviceHeight * 0.35,
              child: Container(
                width: deviceWidth * 0.6,
                height: 93.40714,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.5,color: Theme.of(context).accentColor)
                ),
                child: Stack(children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("¥", style: TextStyle(fontSize: 57.73),),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text( widget.money.toString(), style: TextStyle(fontSize: 57.73),),
                  )
                ]),
              )
            ),
            Container(
              alignment: Alignment.center,
              height: deviceHeight * 0.3,
              child: Container(
                width: deviceWidth* 0.4,
                height: deviceHeight * 0.3 * 0.4,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2.5))
                ),
                child: Stack(children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(
                      text: "残り", style: TextStyle(fontSize: 36.5),
                      children: [
                        TextSpan(text: "            ¥",style: TextStyle(fontSize: 41.425))
                      ]
                    ))
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text( (widget.total + widget.money).toString(), style: TextStyle(fontSize: 41.425),),
                  )
                ]),
              )
            ),
            Container(
              height: deviceHeight * 0.2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("確定", style: TextStyle(fontSize: 41.425),),
                    onPressed: () async {
                      // 入金処理終了フラグ送信
                      bool flg = await HttpRes.sendDepositFlg(false);
                      if(flg){
                        Navigator.pop(context,"return");
                      }
                    }
                  ),
                ],
              ),
            )
          ]);
        })
      )
    );
  }
}
