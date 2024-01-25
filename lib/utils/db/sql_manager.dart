import 'dart:io';

import 'package:flutter_chat_craft/utils/db/session_db_provider.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class SQLManager {
  static const _version = 1;
  static const _name = "chatChart.db";

  static Database? _database;

  static var _isInit;

  static init() async {
    close();
    _isInit = true;
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _name);
    _database = await openDatabase(path,
        version: _version, onCreate: (Database db, int version) async {});

    //Initialize local Session table.
    SessionDbProvider session = SessionDbProvider();
    var exist = await isTableExits(session.tableName());
  }

  /// 获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_isInit == false) {
      await init();
    }
    return _database!;
  }

  /// 判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database?.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.isNotEmpty;
  }

  /// Clean up the database.
  static cleanup() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _name);
    File file = File(path);
    if (await file.exists()) {
      file.deleteSync();
    }
  }

  /// close database
  static close() {
    _database?.close();
    _database = null;
  }
}
