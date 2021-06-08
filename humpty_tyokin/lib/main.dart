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
    return MaterialApp(
      title: 'APIをPOSTで呼び出しJSONパラメータを渡す',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Api JSON Post Sample'),
        ),
        body: Center(
          child: FutureBuilder<ApiResults>(
            future: res,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: [
                      Text(
                          snapshot.data.message.toString()
                      ),
                      Container(
                        height: 300,
                        child: ListView.separated(
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index){
                              return Row(
                                children: [
                                  Text(
                                      snapshot.data.data[index]["userid"].toString(),
                                      style: TextStyle(backgroundColor: Colors.redAccent,),
                                  ),
                                  Text(
                                      snapshot.data.data[index]["datetime"].toString(),
                                      style: TextStyle(backgroundColor: Colors.blueAccent,),
                                  ),
                                  Text(
                                      snapshot.data.data[index]["money"].toString(),
                                      style: TextStyle(backgroundColor: Colors.greenAccent,),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index){
                              return Divider(height:5,);
                            },
                      ),

                      )
                    ],
                  )

                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
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