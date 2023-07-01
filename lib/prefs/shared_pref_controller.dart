import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
enum Prefkeys{
 id ,name, logged_in , email , language
}
class SharedPrefController{
  SharedPrefController._();
   late SharedPreferences _sharedPreferences;
  static SharedPrefController? _instance;
  factory SharedPrefController(){
    return _instance ??= SharedPrefController._();
  }

  Future<void> initPrefrences()async {
     _sharedPreferences =  await SharedPreferences.getInstance();
  }
  void save({required User user}){
    _sharedPreferences.setBool(Prefkeys.logged_in.name, true);
    _sharedPreferences.setInt(Prefkeys.id.name, user.id );
    _sharedPreferences.setString(Prefkeys.name.name, user.name );
    _sharedPreferences.setString(Prefkeys.email.name, user.email );


  }
  get loggedIn => _sharedPreferences.getBool(Prefkeys.logged_in.name)?? false;
  Future<bool> clear(){
    return _sharedPreferences.clear();
  }
  T? getValueFor<T>(String key){
    if(_sharedPreferences.containsKey(key)){
      return _sharedPreferences.get(key) as T;
    }
    return null;
  }

  void changeLanguage(String language){
    _sharedPreferences.setString(Prefkeys.language.name, language);
  }
  
}