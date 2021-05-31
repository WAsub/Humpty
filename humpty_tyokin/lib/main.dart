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
                return Text(
                    snapshot.data.message.toString()
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
  ApiResults({
    this.message,
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      message: json['message'],
    );
  }
}

Future<ApiResults> fetchApiResults() async {
  var url = "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php";
  var request = new SampleRequest(id: 1234, name: '大和賢一郎');
  final response = await http.post(url,
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class SampleRequest {
  final int id;
  final String name;
  SampleRequest({
    this.id,
    this.name,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}