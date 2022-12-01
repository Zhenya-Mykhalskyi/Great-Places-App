import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user_places.db'),
        //створює бд по визначеному шляху із закінченням places.db
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
    //if it doesn`t find database, it will create
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data, //те, що получимо в якосты аргумента функції
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
      //якщо вже є такий запис, то він перезапишеться на новий
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table); //отримати дб
  }
}
