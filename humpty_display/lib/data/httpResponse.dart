import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiResults.dart';
import 'sqlite.dart';

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
/** 出金額送信用 */
class WithdrawMoneyRequest {
  final Thokin money;
  WithdrawMoneyRequest({
    this.money,
  });
  Map<String, dynamic> toJson() => {
    'withdrawMoney': money.toMap(),
  };
}
/** 入金処理開始フラグ送信 */
class DepositFlgRequest{
  final DateTime date;
  final bool flg;
  DepositFlgRequest({
    this.date,
    this.flg,
  });
  Map<String, dynamic> toJson() => {
    'date': date,
    'flg': flg,
  };
}
/** 入金額取得用 */
class DepositMoneyRequest{
  final bool flg;
  DepositMoneyRequest({
    this.flg,
  });
  Map<String, dynamic> toJson() => {
    'flg': flg,
  };
}
/** HTTP通信系まとめ */
class HttpRes{
  static Future<void> getThokinData(String id) async {
    /** HTTP通信 */
    ApiResults httpRes;
    print(DataRequest(userid: id).toJson());
    /** サーバーからデータを取得 */
    httpRes = await fetchApiResults(
      "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
      new DataRequest(userid: id).toJson()
    );
    print(httpRes.message);
    print(httpRes.data);
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
  /** 出金額送信 */
  static Future<void> sendWithdrawMoney(Map<int,int> data) async {
    /** HTTP通信 */
    ApiResults httpRes;
    /** Thokinに入れ替え */
    DateTime now = DateTime.now();
    final Thokin money = Thokin(
      date: now,
      five_hundred_yen: data[500],
      hundred_yen: data[100],
      fifty_yen: data[50],
      ten_yen: data[10],
      five_yen: data[5],
      one_yen: data[1]
    );
    print(WithdrawMoneyRequest(money: money).toJson());
    /** サーバーへ送信 */
    bool flg = false;
    while (!flg) {
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new WithdrawMoneyRequest(money: money).toJson()
      );
      print(httpRes.message);
      print(httpRes.data);
      if (httpRes.message != "Failed") {
        flg = true;
      }
      flg = true; // TODO テスト用
    }
  }
  /** 入金処理開始フラグ送信 */
  static Future<void> sendDepositFlg(bool sendflg) async {
    /** HTTP通信 */
    ApiResults httpRes;
    /** Thokinに入れ替え */
    DateTime now = DateTime.now();
    print(DepositFlgRequest(date: now, flg: sendflg).toJson());
    /** サーバーへ送信 */
    bool flg = false;
    while (!flg) {
      httpRes = await fetchApiResults(
        "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
        new DepositFlgRequest(date: now, flg: true).toJson()
      );
      print(httpRes.message);
      print(httpRes.data);
      if (httpRes.message != "Failed") {
        flg = true;
      }
      flg = true; // TODO テスト用
    }
  }
  /** 入金額取得 */
  static Future<int> getDepositMoney() async {
    /** HTTP通信 */
    ApiResults httpRes;
    print(DepositMoneyRequest(flg: true).toJson());
    /** サーバーへデータを送信 */
    httpRes = await fetchApiResults(
      "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
      new DepositMoneyRequest(flg: true).toJson()
    );
    print(httpRes.message);
    print(httpRes.data);
    if (httpRes.message != "Failed") {
      return httpRes.data["money"];
    }
    return 233; // TODO テスト用
  }
}