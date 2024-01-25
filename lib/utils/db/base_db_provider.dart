import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/utils/db/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDbProvider {
  bool isTableExits = false;

  createTableString();

  tableName();

  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  /// super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await SQLManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await SQLManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  /// super 打开数据表
  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await SQLManager.getCurrentDatabase();
  }
}
