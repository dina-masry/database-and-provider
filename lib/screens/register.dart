import 'package:database/database/user_db_controller.dart';
import 'package:database/extensions/context_extensions.dart';
import 'package:database/process_response.dart';
import 'package:database/widgets/appTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user.dart';
class Regiser extends StatefulWidget {
  const Regiser({Key? key}) : super(key: key);

  @override
  State<Regiser> createState() => _RegiserState();
}

class _RegiserState extends State<Regiser> {
  late TextEditingController _nameController ;
  late TextEditingController _emailController ;
  late TextEditingController _passwordController;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(context.localizations.register),

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.localizations.register_title, style: GoogleFonts.cairo(
                fontSize: 25.sp ,
                fontWeight: FontWeight.w500
            ),),
            Text(context.localizations.register_subtitle, style: GoogleFonts.cairo(
                fontSize: 20.sp ,
                fontWeight: FontWeight.w300)),
            SizedBox(height: 10.h,),
            AppTextField( title: context.localizations.name, icon: Icons.person, textInputType: TextInputType.text, controller: _nameController,),
            SizedBox(height: 10.h,),
            AppTextField( title: context.localizations.email, icon: Icons.email, textInputType: TextInputType.emailAddress, controller: _emailController,),
            SizedBox(height: 10.h,),
            AppTextField(title: context.localizations.password, icon: Icons.lock, obscure: true, textInputType: TextInputType.visiblePassword,controller:_passwordController,),
            SizedBox(height: 20.h,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity , 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),

                ),
                onPressed: (){_performRegiser();},
                child:  Text(context.localizations.register))

          ],
        ),
      ),
    );
  }
  void _performRegiser(){
    if(_checkData())
      _Regiser();
  }
  bool _checkData(){
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      return true;
    }
    context.showSnackBar(message: context.localizations.register_subtitle , error: true);
    return false;
  }
  void _Regiser()async{
    ProcessResponse processResponse = await UserDbController().register(user: user);
    if(processResponse.success){
      Navigator.pop(context);
    }
    context.showSnackBar(message: processResponse.message, error: !processResponse.success);
  }
  User  get user{
    User user = User();
    user.name = _nameController.text;
    user.email = _emailController.text;
    user.password = _passwordController.text;

    return user;
}
}
