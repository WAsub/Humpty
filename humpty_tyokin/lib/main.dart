import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<ApiResults> res;
  @override
  void initState() {
    super.initState();
    res = fetchApiResults();
  }
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
    List<Widget> leadingIcon = [Icon(Icons.radio_button_off), Icon(Icons.article_sharp), Icon(Icons.settings),];
    List<Widget> titleText = [Text("user"), Text("お知らせ"), Text("アカウント設定"),];
    // var onTap = [null, PastRecord(), SetLine(), SetTheme(), Config(),];
    return MaterialApp(
      title: 'APIをPOSTで呼び出しJSONパラメータを渡す',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('はんぷてぃ'),
        ),
        /******************************************************* AppBar*/
        drawer: Drawer(
          child: ListView.builder(
            itemCount: leadingIcon.length,
            itemBuilder: (context, index) {
              if(index == 0){
                return DrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor,),
                  child: Container(
                    // color: Colors.blue,
                    alignment: Alignment.bottomRight,
                    child: ListTile(
                      leading:leadingIcon[index], // 左のアイコン
                      title: titleText[index], // テキスト
                      onTap: (){},
                    ),
                  ),
                );
              }else{
                return ListTile(
                  leading:leadingIcon[index], // 左のアイコン
                  title: titleText[index], // テキスト
                  onTap: (){},
                );
              }
            },
          ),
        ),
        /******************************************************* Drawer*/
        body: LayoutBuilder(
            builder: (context, constraints) {
              deviceHeight = constraints.maxHeight;
              deviceWidth = constraints.maxWidth;

              return Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.redAccent,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 29.124,
                      width: 110,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(Icons.monetization_on_outlined),
                            Text("現在高",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ]
                      ),
                    ),
                  ),
                  Container(
                    height: deviceHeight - 50,
                    alignment: Alignment.center,
                    color: Colors.greenAccent,
                    child:Container(
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.purpleAccent,
                            strokeWidth: 230,
                            value: 0.7,
                          ),
                          Container(
                            height: 256,
                            width: 256,
                            // margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(128),
                                color: Colors.blueAccent
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("4600",style: TextStyle(fontSize: 60,fontWeight: FontWeight.w200),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.flag),Text("10000")
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                    // Center(
                    //   child: FutureBuilder<ApiResults>(
                    //     future: res,
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         var total = 0;
                    //         for(var i = 0; i < snapshot.data.data.length; i++){
                    //           total += snapshot.data.data[i]["money"];
                    //         }
                    //         return Container(
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                     snapshot.data.message.toString()
                    //                 ),
                    //                 Container(
                    //                   height: 300,
                    //                   child: ListView.separated(
                    //                     itemCount: snapshot.data.data.length,
                    //                     itemBuilder: (context, index){
                    //                       return Column(
                    //                         children: [
                    //                           Text(total.toString()),
                    //                           Row(
                    //                             children: [
                    //                               Text(
                    //                                 snapshot.data.data[index]["userid"].toString(),
                    //                                 style: TextStyle(backgroundColor: Colors.redAccent,),
                    //                               ),
                    //                               Text(
                    //                                 snapshot.data.data[index]["datetime"].toString(),
                    //                                 style: TextStyle(backgroundColor: Colors.blueAccent,),
                    //                               ),
                    //                               Text(
                    //                                 snapshot.data.data[index]["money"].toString(),
                    //                                 style: TextStyle(backgroundColor: Colors.greenAccent,),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       );
                    //
                    //                     },
                    //                     separatorBuilder: (context, index){
                    //                       return Divider(height:5,);
                    //                     },
                    //                   ),
                    //
                    //                 )
                    //               ],
                    //             )
                    //
                    //         );
                    //       } else if (snapshot.hasError) {
                    //         return Text("${snapshot.error}");
                    //       }
                    //       return CircularProgressIndicator();
                    //     },
                    //   ),
                    // ),
                ],
              );
            }),
      )
    );
  }
}

class ApiResults {
  final String message;
  final List<dynamic> data;
  // final DateTime datetime;
  // final String money;
  ApiResults({
    this.message,
    this.data,
    // this.datetime,
    // this.money,
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    var a = json;
    var c = ApiResults(
        message: json['message'],
        data: json['data']
    );
    var d = c.data[0]["userid"];
    var e = c.data.length;
    return ApiResults(
      message: json['message'],
      data: json['data']
    );
  }
}

Future<ApiResults> fetchApiResults() async {
  var url = "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php";
  var request = new SampleRequest(userid: "abc");
  final response = await http.post(url,
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    var b = response.body;
    var j = json.decode(response.body);
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class SampleRequest {
  final String userid;
  // final DateTime datetime;
  // final String money;
  SampleRequest({
    this.userid,
    // this.datetime,
    // this.money,
  });
  Map<String, dynamic> toJson() => {
    'userid': userid,
    // 'datetime': datetime,
    // 'money': money,
  };
}