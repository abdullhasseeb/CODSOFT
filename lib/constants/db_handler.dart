import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/todo.dart';

class DatabaseHandler{
  //variables for create database
  static bool isEmpty = true;

  setisEmpty(bool isEmpty){
    DatabaseHandler.isEmpty = isEmpty;
  }
  static const dbName = 'tasks_db.db';
  static const dbVersion = 1;
  static const dbTableName = 'todoTasks';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDesc = 'desc';
  static const columnIsDone = 'isDone';

  //constructor
  static final DatabaseHandler instance = DatabaseHandler();

  //initilize database
  static Database? _database;
  static bool check = false;

  bool checkDatabase(){
    if(_database == null){
      return false;
    }
    else{
      return true;
    }
  }
  //check wheather db is null or not
  Future<Database?> get database async{
    if(_database != null){
      check = true;
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  // if database is null then open database
  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, '$dbName');
    return openDatabase(path, version: dbVersion, onCreate: onCreate );
  }

  // and create database
  Future onCreate(Database database, int version) async{
    database.execute(
        '''  
        CREATE TABLE $dbTableName (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDesc TEXT,
        $columnIsDone INTEGER
        )
        '''
    );
  }

  //operations for database

  // insert data into database
   insertTask (ToDo todo) async{
    Database? database = await instance.database;
    final data =  todo.toMap();
    return await database!.insert(dbTableName, data);
   }

   //fetch or read the data from database
   Future<List<ToDo>> readTask()async {
    Database? database = await instance.database;
    final List<Map<String, Object?>> list = await database!.query(dbTableName);
    return list.map((e) => ToDo.fromMap(e)).toList();
   }

   //update data to database
   Future<int> updateTask(Map<String, dynamic> dataRow)async {
    Database? database = await instance.database;
    int id = dataRow[columnId];
     return database!.update(dbTableName, dataRow, where: '$columnId = ?', whereArgs: [id]);
   }

   //delete data from database table
   Future<int> deleteTask(int id) async{
    Database? database = await instance.database;
    return await database!.delete(dbTableName, where: '$columnId = ?', whereArgs: [id]);
   }

   //searchFilter
  Future<List<ToDo>> searchItems(String query) async {
     Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(dbTableName,
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'title ASC');

    return maps.map((e) => ToDo.fromMap(e)).toList();
  }
}