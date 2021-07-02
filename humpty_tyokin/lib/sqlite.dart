import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Thokin {
  String date;
  int money;
  int one_yen;
  int five_yen;
  int ten_yen;
  int fifty_yen;
  int hundred_yen;
  int five_hundred_yen;

  Thokin({this.date, this.money, this.one_yen, this.five_yen, this.ten_yen, this.fifty_yen, this.hundred_yen, this.five_hundred_yen,});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'money': money,
      'one_yen': one_yen,
      'five_yen': five_yen,
      'ten_yen': ten_yen,
      'fifty_yen': fifty_yen,
      'hundred_yen': hundred_yen,
      'five_hundred_yen': five_hundred_yen,
    };
  }
  @override
  String toString() {
    return 'Thokin{date: $date, money: $money, one_yen: $one_yen, five_yen: $five_yen, ten_yen: $ten_yen, fifty_yen: $fifty_yen, hundred_yen: $hundred_yen, five_hundred_yen: $five_hundred_yen}';
  }
}
class Goal {
  String date;
  int goal;
  String memo;
  bool flg;

  Goal({this.date, this.goal, this.memo, this.flg,});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'goal': goal,
      'memo': memo,
      'flg': flg,
    };
  }
  @override
  String toString() {
    return 'Thokin{date: $date, goal: $goal, memo: $memo, flg: $flg}';
  }
}
class SQLite{
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'money_database.db'),
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE thokin("
            "date TEXT, "
            "money INTEGER, "
            "one_yen INTEGER, "
            "five_yen INTEGER, "
            "ten_yen INTEGER, "
            "fifty_yen INTEGER, "
            "hundred_yen INTEGER, "
            "five_hundred_yen INTEGER"
          ")",
        );
        await db.execute(
          "CREATE TABLE goals("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "date TEXT, "
            "goal INTEGER, "
            "memo TEXT, "
            "flg INTEGER)",
        );
        // // テスト用
        await db.execute(
          'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES ("2021-01-03 15:25:07", 400, 0, 0, 0, 2, 3, 0)',
        );
        await db.execute(
          'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES ("2021-01-03 16:20:08", -50, 0, 0, 0, -1, 0, 0)',
        );
        await db.execute(
          'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES ("2021-01-03 16:25:08", 500, 0, 0, 0, 0, 0, 1)',
        );
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

  /** 貯金リスト取得用 */
  static Future<List<Thokin>> getThokin() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM thokin ORDER BY date'
    );
    List<Thokin> list = [];
    for(int i = 0; i < maps.length; i++){
      list.add( Thokin(
        date: maps[i]['date'],
        money: maps[i]['money'],
        one_yen: maps[i]['one_yen'],
        five_yen: maps[i]['five_yen'],
        ten_yen: maps[i]['ten_yen'],
        fifty_yen: maps[i]['fifty_yen'],
        hundred_yen: maps[i]['hundred_yen'],
        five_hundred_yen: maps[i]['five_hundred_yen'],
      ));
    }
    return list;
  }
  /** 貯金リスト登録用 */
  static Future<void> insertThokin(List<Thokin> thokin) async {
    final Database db = await database;
    // リストを順番に登録
    for(int i = 0; i < thokin.length; i++){
      await db.rawInsert(
        'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [thokin[i].date, thokin[i].money, thokin[i].one_yen, thokin[i].five_yen, thokin[i].ten_yen, thokin[i].fifty_yen, thokin[i].hundred_yen, thokin[i].five_hundred_yen]
      );
    }
    
  }
  /** 貯金リスト全削除用 */
  static Future<void> deleteThokin() async {
    final db = await database;
    await db.delete(
      'thokin',
    );
  }
  /** 目標リスト取得 */
  static Future<List<Goal>> getGoal() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM goals ORDER BY date'
    );
    List<Goal> list = [];
    for(int i = 0; i < maps.length; i++){
      list.add( Goal(
        date: maps[i]['date'],
        goal: maps[i]['goal'],
        memo: maps[i]['memo'],
        flg: maps[i]['flg'] != 0 ? true : false,
      ));
    }
    return list;
  }
  /** 今の目標取得(日付順にIDふっているのでIDの最大値の行) */
  static Future<Goal> getGoalNow() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM goals WHERE id = (SELECT MAX(id) FROM goals)'
    );
    Goal maxGoal;
    maxGoal = Goal(
      date: maps[0]['date'],
      goal: maps[0]['goal'],
      memo: maps[0]['memo'],
      flg: maps[0]['flg'] != 0 ? true : false,
    );
    return maxGoal;
  }
  /** 目標リスト登録用 */
  static Future<void> insertGoals(List<Goal> goal) async {
    final Database db = await database;
    // リストを順番に登録
    for(int i = 0; i < goal.length; i++){
      await db.rawInsert(
        'INSERT INTO goals(date, goal, memo, flg) VALUES (?, ?, ?, ?)',
        [goal[i].date, goal[i].goal, goal[i].memo, goal[i].flg,]
      );
    }
  }
  /** 目標登録用 */
  static Future<void> insertGoal(Goal goal) async {
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = outputFormat.format(now);
    print(date);
    final Database db = await database;
    // リストを順番に登録
    await db.rawInsert(
      'INSERT INTO goals(date, goal, memo, flg) VALUES (?, ?, ?, ?)',
      [date, goal.goal, goal.memo, false,]
    );
  }
  /** 貯金リスト全削除用 */
  static Future<void> deleteGoal() async {
    final db = await database;
    await db.delete(
      'goals',
    );
  }

}