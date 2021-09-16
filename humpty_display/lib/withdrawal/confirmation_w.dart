import 'package:flutter/material.dart';
import 'package:humpty_display/data/httpResponse.dart';
import '../costomWidget/previewCoinCount.dart';

class ConfirmationW extends StatefulWidget {
  final int money;
  final Map<int,int> coinData;
  final int total;
  ConfirmationW({
    this.money,
    this.coinData,
    this.total,
    Key key
  }) : super(key: key);

  @override
  _ConfirmationWState createState() => _ConfirmationWState();
}

class _ConfirmationWState extends State<ConfirmationW> {
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
            Container(
              alignment: Alignment.bottomCenter,
              height: deviceHeight * 0.15,
              child: Text("出金金額"),
            ),
            Row(children: [
              Container(
                alignment: Alignment.center,
                width: deviceWidth * 0.5,
                height: deviceHeight * 0.35,
                child: Container(
                  width: deviceWidth * 0.5 * 0.6,
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
                width: deviceWidth * 0.5,
                height: deviceWidth * 0.5 / 3 * 0.95,
                child: PreviewCoinCount(
                  counts: widget.coinData,
                )
              ),
            ],),
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
                    child: Text( (widget.total - widget.money).toString(), style: TextStyle(fontSize: 41.425),),
                  )
                ]),
              )
            ),
            Container(
              height: deviceHeight * 0.2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text("戻る", style: TextStyle(fontSize: 41.425),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                    onPressed: () {
                      Navigator.pop(context,"");
                    }
                  ),
                  TextButton(
                    child: Text("確定", style: TextStyle(fontSize: 41.425),),
                    onPressed: () async {
                      Map<int,int> sendData = widget.coinData;
                      if(sendData == null){
                        sendData = {500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0};
                      }
                      bool flg = await HttpRes.sendWithdrawMoney("c518vjspeg5s0bv4l0c0", sendData);
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
