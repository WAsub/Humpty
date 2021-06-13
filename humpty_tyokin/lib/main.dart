import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<ApiResults> res;

  double swipH = -100;
  @override
  void initState() {
    super.initState();
    res = fetchApiResults();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    List<Widget> leadingIcon = [
      Icon(Icons.radio_button_off),
      Icon(Icons.article_sharp),
      Icon(Icons.settings),
    ];
    List<Widget> titleText = [
      Text("user"),
      Text("お知らせ"),
      Text("アカウント設定"),
    ];
    // var onTap = [null, PastRecord(), SetLine(), SetTheme(), Config(),];
    return MaterialApp(
        title: 'APIをPOSTで呼び出しJSONパラメータを渡す',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('こつみ cotsumi'),
          ),
          /******************************************************* AppBar*/
          drawer: Drawer(
            child: ListView.builder(
              itemCount: leadingIcon.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Container(
                      // color: Colors.blue,
                      alignment: Alignment.bottomRight,
                      child: ListTile(
                        leading: leadingIcon[index], // 左のアイコン
                        title: titleText[index], // テキスト
                        onTap: () {},
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: leadingIcon[index], // 左のアイコン
                    title: titleText[index], // テキスト
                    onTap: () {},
                  );
                }
              },
            ),
          ),
          /******************************************************* Drawer*/
          body: LayoutBuilder(builder: (context, constraints) {
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
                        color: Colors.blueAccent),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on_outlined),
                          Text(
                            "現在高",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
                Container(
                  height: deviceHeight - 50,
                  alignment: Alignment.center,
                  color: Colors.greenAccent,
                  child: Container(
                    child: FutureBuilder<ApiResults>(
                      future: res,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var total = 0;
                          var goal = 1000;
                          for (var i = 0; i < snapshot.data.data.length; i++) {
                            total += snapshot.data.data[i]["money"];
                          }
                          var par = total / goal;

                          return Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                /** どのぐらい目標達成したか */
                                Container(
                                  height: deviceHeight,
                                  width: deviceWidth,
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    child: CustomPaint(
                                      size: Size(deviceWidth, deviceHeight),
                                      painter: CirclePainter(par: par),
                                    ),
                                  ),
                                ),
                                /** 数字類 */
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /** 貯金額 */
                                    Text(
                                      total.toString(),
                                      style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    /** アイコンと目標額 */
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.flag),
                                        Text(goal.toString())
                                      ],
                                    ),
                                  ],
                                ),
                                /** 履歴画面(下スワイプ) */
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 200),
                                  top: deviceHeight + swipH,
                                  child: GestureDetector(
                                    onVerticalDragUpdate:
                                        (DragUpdateDetails details) {
                                      setState(() {
                                        if (details.delta.dy < -10) {
                                          var dy = deviceHeight / 5 * 4.5;
                                          swipH = dy - dy - dy;
                                        }
                                        if (details.delta.dy > 10) {
                                          swipH = -100;
                                        }
                                      });
                                    },
                                    /** 履歴画面 */
                                    child: Container(
                                        color: Colors.brown[500],
                                        width: deviceWidth,
                                        height: deviceHeight / 5 * 4.5,
                                        child: Center(
                                          child: Container(
                                            color: Colors.amberAccent,
                                            width: deviceWidth * 0.9,
                                            height:
                                                deviceHeight / 5 * 4.5 * 0.7,
                                            child: ListView.separated(
                                              itemCount:
                                                  snapshot.data.data.length,
                                              itemBuilder: (context, index) {
                                                debugPrint(
                                                    deviceHeight.toString());
                                                return Row(
                                                  children: [
                                                    Text(
                                                      snapshot.data
                                                          .data[index]["userid"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data
                                                          .data[index]
                                                              ["datetime"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        backgroundColor:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data
                                                          .data[index]["money"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        backgroundColor:
                                                            Colors.greenAccent,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return Divider(
                                                  height: 5,
                                                );
                                              },
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ]);
                        } else if (snapshot.hasError) {
                          /** サーバーから結果が得られなかったときの処理 */ //TODO ローカル保存もするべきか？
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}

class CirclePainter extends CustomPainter {
  final double par;
  CirclePainter({
    this.par,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(20, 20, 280, 280);
    final startAngle = -60 * math.pi / 180;
    final sweepAngle = 300 * math.pi / 180;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

    final paint2 = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    final sweepAngle2 = 300 * math.pi / 180 * par;
    canvas.drawArc(rect, startAngle, sweepAngle2, useCenter, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
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
    var c = ApiResults(message: json['message'], data: json['data']);
    var d = c.data[0]["userid"];
    var e = c.data.length;
    return ApiResults(message: json['message'], data: json['data']);
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
