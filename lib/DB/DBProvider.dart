import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_application/DB/ModelToDo.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get mDatabase async {
    if (_database != null) {
      return _database;
    }
    return _database = await initDB();
  }

  initDB() async {
    // Set the path to the database.
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "ToDoApp.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        // When the database is first created, create a table to store ToDo.
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ToDo (" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
          "task TEXT," +
          "status Integer" +
          ")");
    });
  }

  // Create
  addNewTask(ModelToDo data) async {
    final db = await mDatabase;
    // Insert the ToDo into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    var res = await db.insert("ToDo", data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  // Read
  Future<List<ModelToDo>> getAllToDoListData() async {
    final db = await mDatabase;
    List<Map<String, dynamic>> res = await db.query("ToDo", orderBy: "status ASC, id DESC");
    List<ModelToDo> list =
        res.isNotEmpty ? res.map((d) => ModelToDo.fromMap(d)).toList() : [];
    return list;
    //return List.generate(res.length, (i) {
    //  return ModelToDo(res[i]["id"], res[i]["task"], res[i]["status"]);
    //});
  }

  // Update
  updateToDoById(ModelToDo data) async {
    final db = await mDatabase;
    var res = await db
        .update("ToDo", data.toMap(), where: "id = ?", whereArgs: [data.id]);
    return res;
  }

  // Delete
  deleteToDo(ModelToDo data) async {
    final db = await mDatabase;
    db.delete('ToDo', where: "id = ?", whereArgs: [data.id]);
  }
}
