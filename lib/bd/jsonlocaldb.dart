import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/modelos.dart';

class localdb {
  static iniDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'local.db'),
      onCreate: (db, version) {
        /*return db.execute(
          "drop TABLE dia;",
        );*/
        return db.execute(
          "CREATE TABLE dia(" +
              "id INTEGER PRIMARY KEY autoincrement," +
              "_id TEXT, " +
              "Fecha TEXT, " +
              "inventario TEXT, " +
              "efectivo_base INTEGER)",
        );
      },
      version: 1,
    );
  }

  static insertDog(dia un_dia) async {
    final database = iniDB();
    final db = await database;
    //await db.drop
    /*await db.execute(
      "drop TABLE dia;",
    );*/
    await db.insert(
      'dia',
      {
        'id': null,
        '_id': un_dia.id_dia.toString(),
        'Fecha': un_dia.Fecha,
        'inventario': un_dia.inventario,
        'efectivo_base': un_dia.efectivo_base,
      },
      //un_dia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static dias() async {
    final database = iniDB();
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return maps;
  }

  static updateDog(dia un_dia) async {
    final database = iniDB();
    final db = await database;
    await db.update(
      'dia',
      un_dia.toMap(),
      where: 'id = ?',
      whereArgs: [un_dia.id!],
    );
  }

  static Future<void> deleteDog(int id) async {
    final database = iniDB();
    final db = await database;
    await db.delete(
      'dia',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
