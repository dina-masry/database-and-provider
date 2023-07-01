import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
   AppTextField({
    Key? key,
    required this.title,
    required this.icon ,
    this.textInputType = TextInputType.text ,
    this.obscure = false,
     required this.controller
  }) : super(key: key);
  final String title;
  final IconData icon ;
  bool obscure ;
  final TextInputType textInputType ;
  TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:  controller,
      obscureText: obscure,
      style: GoogleFonts.cairo(),
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: title,
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
                width: 1.w,
                color: Colors.black45
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
                width: 1.w,
                color: Colors.blue
            )
        ),

      ),
    );
  }
}