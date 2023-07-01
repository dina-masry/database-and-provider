import 'package:database/database/db_controller.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class UserDbController{
  final Database _database =DbController().database;

  Future<ProcessResponse> login({required String email , required String password})async{
   List<Map<String , dynamic>> rowMap = await _database.rawQuery('SELECT * FROM users WHERE email =? AND password =?' ,[email , password]);
    if(rowMap.isNotEmpty){
     User user =  User.fromMap(rowMap.first);
     SharedPrefController().save(user: user);
     return ProcessResponse(message: 'Logged in successfully' ,success: true);
    }
    return ProcessResponse(message: 'Login failed!');


  }
  Future<ProcessResponse> register({required User user})async{
    if(await isEmailNotExists(email: user.email)){
     int newRowId = await _database.rawInsert('INSERT INTO users (name , email , password) VALUES(?,?,?)',[user.name , user.email , user.password]);
      return ProcessResponse(message: newRowId!=0 ?'Register success!':'Register failed' , success: newRowId!=0);
    }
     return ProcessResponse(message: 'Email exists ! use another');


  }
  Future<bool> isEmailNotExists({required String email})async{
    List<Map<String ,dynamic>> rowMap = await _database.query(User.tableName , where: 'email = ?' , whereArgs: [email]);
    return rowMap.isEmpty;
  }

}