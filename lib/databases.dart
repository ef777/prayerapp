import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/counter_model.dart';

class DatabaseHelper {
  static final _databaseName = "myDatabase7.db";
  static final _databaseVersion = 1;

  static final table = 'my_table93';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnStart = 'start';
  static final columnFinish = 'finish';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnStart TEXT NOT NULL,
            $columnFinish TEXT NOT NULL 
          )
          ''');
  }

  // Helper methods

  // Insert a row
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<CounterModel>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table);
    return List.generate(result.length, (i) {
      return CounterModel(
        id: result[i]['_id'] as int?,
        title: result[i]['title'] as String,
        finish: result[i]['finish'] as String,
        start: result[i]['start'] as String,
      );
    });
  }

  // Delete a row
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(int id, fin) async {
    Database db = await instance.database;
    return await db.update(table, {'start': fin},
        where: '$columnId = ?', whereArgs: [id]);
  }
}
