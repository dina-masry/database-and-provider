import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext{
   void showSnackBar({required String message , bool error =false}){
     ScaffoldMessenger.of(this).showSnackBar(
       SnackBar(
         content:Text(message),
         duration: const Duration(seconds: 2),
         backgroundColor: error? Colors.red : Colors.green,
       )
     );
   }
   AppLocalizations get localizations => AppLocalizations.of(this)!;

}