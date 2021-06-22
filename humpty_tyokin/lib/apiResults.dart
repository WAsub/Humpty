
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


class ApiResults {
  final String message;
  final List<dynamic> data;
  ApiResults({
    this.message,
    this.data,
  });
  factory ApiResults.errorMsg(String msg) {
    return ApiResults(message: msg, data: null);
  }
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(message: json['message'], data: json['data']);
  }
}

Future<ApiResults> fetchApiResults(url, requestMap) async {
  // var url = "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php";
  // var request = new SampleRequest(userid: "abc");
  final response = await http.post(url, body: json.encode(requestMap), headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    return ApiResults.errorMsg("Failed");
    // throw Exception('Failed');
  }
}