import 'package:shared_preferences/shared_preferences.dart';
import 'package:humpty_tyokin/data/apiResults.dart';
import 'package:humpty_tyokin/data/sqlite.dart';

/** 貯金データ取得用 */
class DataRequest {
  final String userid;
  DataRequest({
    this.userid,
  });
  Map<String, dynamic> toJson() => {
    'userid': userid,
  };
}
/** リモートデータベースの目標リスト更新用 */
class GoalUpdateRequest {
  final List<Map<String, dynamic>> goallist;
  GoalUpdateRequest({
    this.goallist,
  });
  Map<String, dynamic> toJson() => {
    'goallist': goallist,
  };
}
/** アカウント作成用 */
class SignUpRequest {
  final String username;
  final String userpass;
  SignUpRequest({
    this.username,
    this.userpass,
  });
  Map<String, dynamic> toJson() => {
    'username': username,
    'userpass': userpass,
  };
}
/** ニックネーム変更用 */
class ChengeNameRequest {
  final String username;
  ChengeNameRequest({
    this.username,
  });
  Map<String, dynamic> toJson() => {
    'username': username,
  };
}
/** HTTP通信系まとめ */
class HttpRes{
  /** 貯金データ取得 */
  static Future<void> getThokinData() async {
    /** HTTP通信 */
    ApiResults httpRes;
    /** ユーザーIDを引き出して */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myId = (prefs.getString('myid') ?? "");
    print("HttpRes.DataRequest:${DataRequest(userid: myId).toJson()}");
    /** サーバーからデータを取得 */
    httpRes = await fetchApiResults(
      "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
      new DataRequest(userid: myId).toJson()
    );
    print("message:${httpRes.message}");
    print("data:${httpRes.data}");
    /** データを取得できたらローカルのデータを入れ替え */
    if (httpRes.message != "Failed") {
      List<Thokin> thokin = [];
      for (int i = 0; i < httpRes.data.length; i++) {
        thokin.add(Thokin(
          date: httpRes.data[i]["datetime"],
          money: httpRes.data[i]["money"],
          one_yen: httpRes.data[i]['one_yen'],
          five_yen: httpRes.data[i]['five_yen'],
          ten_yen: httpRes.data[i]['ten_yen'],
          fifty_yen: httpRes.data[i]['fifty_yen'],
          hundred_yen: httpRes.data[i]['hundred_yen'],
          five_hundred_yen: httpRes.data[i]['five_hundred_yen'],
        ));
      }
      await SQLite.deleteThokin();
      await SQLite.insertThokin(thokin);
    }
  }
  /** リモートデータベースの目標リスト更新 */
  static Future<void> remoteGoalsUpdate() async {
    /** HTTP通信 */
    ApiResults httpRes;
    /** ユーザーIDを引き出して */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myId = (prefs.getString('myid') ?? "");
    /** 目標リスト引き出してIDを穴埋め */
    List<Map<String, dynamic>> glist = [];
    List<Goal> list = await SQLite.getGoal();
    for(int i = 0; i < list.length; i++){
      list[i].userId = myId;
      glist.add(list[i].toMap());
    }
    print("HttpRes.GoalUpdateRequest:${GoalUpdateRequest(goallist: glist).toJson()}");
    /** サーバーへ登録 */
    bool flg = false;
    while (!flg) {
      /** サーバーへデータを送信 */
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new GoalUpdateRequest(goallist: glist).toJson()
      );
      print("message:${httpRes.message}");
      print("data:${httpRes.data}");
      /** 成功したら端末に保存 */
      if(httpRes.message != "Failed"){
        flg = true;
      }
      flg = true; // TODO テスト用
    }
  }
  /** アカウント作成 */
  static Future<void> signUp(String name, String pass) async {
    /** HTTP通信 */
    ApiResults httpRes;
    print("HttpRes.SignUpRequest${SignUpRequest(username: name, userpass: pass).toJson()}");
    bool flg = false;
    while (!flg) {
      /** サーバーへデータを送信 */
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new SignUpRequest(username: name, userpass: pass).toJson()
      );
      print("message:${httpRes.message}");
      print("data:${httpRes.data}");
      /** 成功したら端末に保存 */
      if(httpRes.message != "Failed"){
        String myid = httpRes.data["userid"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("myid", myid);
        await prefs.setString("myname", name);
        await prefs.setString("mypass", pass);
        await prefs.setBool("first", true);
        await prefs.setBool("login", true);
        flg = true;
      }
      // TODO テスト用
      String myid = "abc"; 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("myid", myid);
      await prefs.setString("myname", name);
      await prefs.setString("mypass", pass);
      await prefs.setBool("first", true);
      await prefs.setBool("login", true);
      flg = true;
      // TODO テスト用
    }
  }
  /** ニックネーム変更用 */
  static Future<void> chengeName(String name) async {
    /** HTTP通信 */
    ApiResults httpRes;
    print("HttpRes.ChengeNameRequest:${ChengeNameRequest(username: name,).toJson()}");
    bool flg = false;
    while (!flg) {
      /** サーバーへデータを送信 */
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new ChengeNameRequest(username: name,).toJson()
      );
      print("message:${httpRes.message}");
      print("data:${httpRes.data}");
      /** 成功したら端末に保存 */
      if(httpRes.message != "Failed"){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("myname", name);
        flg = true;
      }
      // TODO テスト用
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("myname", name);
      flg = true;
      // TODO テスト用
    }
  }
}