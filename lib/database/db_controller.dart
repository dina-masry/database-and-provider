import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController{
  DbController._();
   late Database _database;
   Database get database => _database;
  static DbController? _instance;
  factory DbController(){
    return _instance ??=DbController._();
  }
  Future<void> initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path ,'db.sql');
    _database = await openDatabase(path , version: 1,
      onOpen: (Database database){},
      onCreate: (Database database , int version)async{
        /// TODO: CREATE DATABASE TABLES USING SQL (users , notes)
        await database.execute('CREATE TABLE users ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT NOT NULL,'
        'email TEXT NOY NULL,'
        'password TEXT NOT NULL'
        ')');
        await database.execute('CREATE TABLE notes ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title TEXT NOT NULL,'
        'info TEXT,'
        'user_id INTEGER,'
        'FOREIGN KEY (user_id) references users(id)'
        ')');

      },
      onUpgrade: (Database database, int newVersion , int oldVersion){},
      onDowngrade: (Database database , int newVersion , int oldVersion){},



    );
  }

}