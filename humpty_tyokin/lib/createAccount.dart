import 'package:flutter/material.dart';
import 'package:humpty_tyokin/initialSetting.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    return  WillPopScope(
      onWillPop: ()async=> false,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [
                        0.2,
                        0.7,
                      ],
                      colors: [
                        Color(0xff85b103),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight*0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.yellowAccent,
                            ),
                            Text("新しい貯金アプリ",
                            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: deviceHeight*0.15,
                        child: Text("私たちと貯金を始めましょう！",
                        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: FlatButton(
                          child: Text('設定を行う',style: TextStyle(color: Color(0xff85b103)),),
                          color: Colors.white,
                          shape: StadiumBorder(),
                          onPressed: () {
                            Navigator .of(context).push(
                              MaterialPageRoute(builder: (context) {
                                // 初期設定へ
                                return InitialSetting();}),
                            ).then((value) async{
                              // reload();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // Stack(children: [
                  //     Container(
                  //       child: IconButton(icon: Icon(Icons.ac_unit_outlined),
                  //       onPressed: (){
                  //         Navigator.pop(context, '戻ります');
                  //       },),
                  //     )
                  // ],)
                );
          
          
          
        })
      )
    );
  }

}