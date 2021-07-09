import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Thokin {
  DateTime date;
  int money;
  int one_yen;
  int five_yen;
  int ten_yen;
  int fifty_yen;
  int hundred_yen;
  int five_hundred_yen;

  Thokin({
    this.date,
    this.money,
    this.one_yen,
    this.five_yen,
    this.ten_yen,
    this.fifty_yen,
    this.hundred_yen,
    this.five_hundred_yen,
  });

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
  String userId;
  DateTime entryDate;
  DateTime achieveDate;
  int goal;
  String memo;
  bool flg;

  Goal({
    this.userId,
    this.entryDate,
    this.achieveDate,
    this.goal,
    this.memo,
    this.flg,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'entryDate': entryDate,
      'achieveDate': achieveDate,
      'goal': goal,
      'memo': memo,
      'flg': flg,
    };
  }

  @override
  String toString() {
    return 'Thokin{userId: $userId, entryDate: $entryDate, achieveDate: $achieveDate, goal: $goal, memo: $memo, flg: $flg}';
  }
}

class SQLite {
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'money_database.db'),
      onCreate: (db, version) async {
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
          "entryDate TEXT, "
          "achieveDate TEXT, "
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
        await db.execute(
          'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES ("2021-01-05 16:25:08", -10, 0, 0, -1, 0, 0, 0)',
        );
        await db.execute(
          'INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES ("2021-01-12 16:25:08", 200, 0, 0, 0, 0, 2, 0)',
        );
      },
      version: 1,
    );
    return _database;
  }

  /** データ加工用 */
  static List<DateTime> getWeekStartEnd(DateTime datetime) {
    int weekday = datetime.weekday;
    DateTime sDate = datetime.add(Duration(days: -(weekday - 1)));
    DateTime eDate = datetime.add(Duration(days: 7 - weekday));
    sDate = DateTime(sDate.year, sDate.month, sDate.day, 0, 0, 0);
    eDate = DateTime(eDate.year, eDate.month, eDate.day, 23, 59, 59, 999);
    return [sDate, eDate];
  }

  /** 貯金リスト取得用 */
  static Future<List<Thokin>> getThokin() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM thokin ORDER BY date');
    List<Thokin> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Thokin(
        date: DateTime.parse(maps[i]['date']),
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

  /** 週間貯金リスト取得用 */
  static Future<List<Thokin>> getWeeklyThokin(DateTime datetime) async {
    int weekday = datetime.weekday;
    DateTime sDate = datetime.add(Duration(days: -(weekday - 1)));
    DateTime eDate = datetime.add(Duration(days: 7 - weekday));
    sDate = DateTime(sDate.year, sDate.month, sDate.day, 0, 0, 0);
    eDate = DateTime(eDate.year, eDate.month, eDate.day, 23, 59, 59, 999);

    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM thokin WHERE date >= ? AND date <= ? ORDER BY date', [format.format(sDate), format.format(eDate)]);
    List<Thokin> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Thokin(
        date: DateTime.parse(maps[i]['date']),
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
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを順番に登録
    for (int i = 0; i < thokin.length; i++) {
      await db.rawInsert('INSERT INTO thokin(date, money, one_yen, five_yen, ten_yen, fifty_yen, hundred_yen, five_hundred_yen) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', [format.format(thokin[i].date), thokin[i].money, thokin[i].one_yen, thokin[i].five_yen, thokin[i].ten_yen, thokin[i].fifty_yen, thokin[i].hundred_yen, thokin[i].five_hundred_yen]);
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
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM goals ORDER BY entryDate');
    List<Goal> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Goal(
        entryDate: DateTime.parse(maps[i]['entryDate']),
        achieveDate: maps[i]['achieveDate'] == null ? null : DateTime.parse(maps[i]['achieveDate']),
        goal: maps[i]['goal'],
        memo: maps[i]['memo'],
        flg: maps[i]['flg'] != 0 ? true : false,
      ));
    }
    print("Goals:$list");
    return list;
  }

  /** 今の目標取得(日付順にIDふっているのでIDの最大値の行) */
  static Future<Goal> getGoalNow() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = [];
    maps = await db.rawQuery('SELECT * FROM goals WHERE id = (SELECT MAX(id) FROM goals)');
    Goal maxGoal;
    maxGoal = maps.isEmpty
        ?
        // データが空の場合
        Goal(
            entryDate: null,
            achieveDate: null,
            goal: null,
            memo: null,
            flg: true,
          )
        :
        // データがある場合
        Goal(
            entryDate: DateTime.parse(maps[0]['entryDate']),
            achieveDate: maps[0]['achieveDate'] == null ? null : DateTime.parse(maps[0]['achieveDate']),
            goal: maps[0]['goal'],
            memo: maps[0]['memo'],
            flg: maps[0]['flg'] != 0 ? true : false,
          );
          print("maxGoal:$maxGoal");
    return maxGoal;
  }
  /** 今の目標取得(日付順にIDふっているのでIDの最大値の行) */
  static Future<int> getGoalNowId() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = [];
    maps = await db.rawQuery('SELECT MAX(id) FROM goals');
    int maxGoalId;
    maxGoalId = maps.isEmpty ? null : maps[0]['MAX(id)'];
    print("maxGoalId:$maxGoalId");
    return maxGoalId;
  }
  /** 目標登録用 */
  static Future<void> insertGoal(Goal goal) async {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを順番に登録
    await db.rawInsert('INSERT INTO goals(entryDate, achieveDate, goal, memo, flg) VALUES (?, ?, ?, ?, ?)', [
      format.format(now),
      null,
      goal.goal,
      goal.memo,
      false,
    ]);
  }
  /** 現在目標更新用 */
  static Future<void> updateNowGoal(int money) async {
    int nowID = await getGoalNowId();
    final Database db = await database;
    // リストを順番に登録
    await db.rawUpdate(
      'UPDATE goals SET goal = ? WHERE id = ?', 
      [money, nowID]
    );
  }
  /** 目標達成登録用 */
  static Future<void> achieveNowGoal(bool flg) async {
    int nowID = await getGoalNowId();
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを順番に登録
    await db.rawUpdate(
      'UPDATE goals SET flg = ?, achieveDate = ? WHERE id = ?', 
      [flg, format.format(now), nowID]
    );
  }
}
