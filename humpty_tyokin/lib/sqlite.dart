import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Thokin {
  int id;
  int money;
  String date;

  Thokin({this.id, this.date, this.money,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'money': money,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, date: $date, money: $money}';
  }
}

class SQLite{
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'money_database.db'),
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE thokin("
              "id TEXT , "
              "date TEXT, "
              "money INTEGER"
              ")",
        );
        // await db.execute(
        //   "CREATE TABLE images("
        //       "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        //       "fid INTEGER , "
        //       "image TEXT)",
        // );
        // await db.execute(
        //   "CREATE TABLE setting("
        //       "deadline INTEGER , "
        //       "paymentDate INTEGER)",
        // );
        // await db.execute(
        //   'INSERT INTO setting VALUES(15, 10)',
        // );
        // // テスト用
        // await db.execute(
        //   'INSERT INTO moneys(money, date) VALUES(1000, "2021-01-01")',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, date) VALUES(1000, "2021-01-03")',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, date) VALUES(257, "2021-01-03")',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, date) VALUES(8000, "2021-01-07")',
        // );
      },
      version: 1,
    );
    return _database;
  }

  /// 貯金リスト取得用
  static Future<List<Thokin>> getThokin() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM thokin ORDER BY date'
    );
    List<Thokin> list = [];
    for(int i = 0; i < maps.length; i++){
      list.add( Thokin(
            id: maps[i]['id'],
            date: maps[i]['date'],
            money: maps[i]['money'],
      ));
    }
    return list;
  }
  /// 貯金リスト登録用
  static Future<void> insertThokin(List<Thokin> thokin) async {
    final Database db = await database;
    // リストを順番に登録
    for(int i = 0; i < thokin.length; i++){
      await db.rawInsert(
        'INSERT INTO thokin(id, money, date) VALUES (?, ?, ?)',
          [thokin[i].id, thokin[i].money, thokin[i].date]
      );
    }
    
  }
  /// 貯金リスト全削除用
  static Future<void> deleteThokin() async {
    final db = await database;
    await db.delete(
      'thokin',
    );
  }

  
}