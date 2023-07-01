import 'package:database/prefs/shared_pref_controller.dart';
import 'package:flutter/material.dart';
class LanguageProvider extends ChangeNotifier{
  String language = SharedPrefController().getValueFor<String>(Prefkeys.language.name) ?? 'en';
  void changeLanguage(){
    language = language=='en' ? 'ar': 'en';
    SharedPrefController().changeLanguage(language);
    notifyListeners();
  }
}