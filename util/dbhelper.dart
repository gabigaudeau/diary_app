import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:diary_app/model/entry.dart';

class DbHelper {
  // FIELDS
  static final DbHelper _dbHelper = DbHelper._internal();
  static Database _db;
  String tblEntry = "entry";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";
  DbHelper._internal();

  // METHODS
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }

    return _db;
  }

  // Create database
  Future<Database> initializeDb() async {
    // Return the directory for the documents of our apps
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "entries.db";
    var dbEntries = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbEntries;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblEntry($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Entry entry) async {
    Database db = await this.db;
    var result = await db.insert(tblEntry, entry.toMap());
    return result;
  }

  Future<List> getEntry() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblEntry order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM $tblEntry"));
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    var db = await this.db;
    var result = await db.update(tblEntry, entry.toMap(),
        where: "$colId = ?", whereArgs: [entry.id]);
    return result;
  }

  Future<int> deleteEntry(int id) async {
    var db = await this.db;
    int result = await db.rawDelete("DELETE FROM $tblEntry WHERE $colId = $id");
    return result;
  }
}
