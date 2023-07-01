import 'package:database/database/user_db_controller.dart';
import 'package:database/extensions/context_extensions.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:database/provider/language_provider.dart';
import 'package:database/widgets/appTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController ;
  late TextEditingController _passwordController;
   late String _language  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _language = SharedPrefController().getValueFor<String>(Prefkeys.language.name)?? 'en';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.login),
        actions: [IconButton(onPressed: (){_showLanguageBottomSheet();}, icon: const Icon(Icons.language))],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.login_title, style: GoogleFonts.cairo(
              fontSize: 28.sp ,
              fontWeight: FontWeight.w500
            ),),
            Text(AppLocalizations.of(context)!.login_subtitle, style: GoogleFonts.cairo(
                fontSize: 22.sp ,
                fontWeight: FontWeight.w300)),
            SizedBox(height: 20.h,),
            AppTextField( title: AppLocalizations.of(context)!.email, icon: Icons.email, textInputType: TextInputType.emailAddress, controller: _emailController,),
            SizedBox(height: 10.h,),
            AppTextField(title: AppLocalizations.of(context)!.password, icon: Icons.lock, obscure: true, textInputType: TextInputType.visiblePassword,controller:_passwordController,),
            SizedBox(height: 20.h,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity , 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),

              ),
                onPressed: (){_performLogin();},
                child:  Text(AppLocalizations.of(context)!.login))  ,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.localizations.do_not_have_an_account),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/register');
                }, child: Text(context.localizations.create))
              ],
            )

          ],
        ),
      ),
    );
  }
  void _performLogin(){
    if(_checkData())
      _login();
  }
  bool _checkData(){
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      return true;
    }
    return false;
  }
  void _login()async{
     ProcessResponse processResponse= await UserDbController().login(email: _emailController.text, password: _passwordController.text);
     if(processResponse.success){
       Navigator.pushReplacementNamed(context, '/home');
     context.showSnackBar(message: context.localizations.login_success);
     }
     if(!processResponse.success){
       context.showSnackBar(message: context.localizations.login_failed , error: true);
     }
  }
  void _showLanguageBottomSheet() async{
    String? langCode = await showModalBottomSheet<String>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        ),
        clipBehavior: Clip.antiAlias,
        builder: (context){
          return StatefulBuilder(
            builder:(context, setState) {
              return BottomSheet(onClosing: (){}, builder: (context){
                return Padding(
                  padding:  EdgeInsets.all(20.0.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.change_language , style: GoogleFonts.cairo(
                        height: 1.0,
                      ),),
                      SizedBox(height: 10.h,),
                      Text(AppLocalizations.of(context)!.choose_language),
                      Divider(color: Colors.purple.shade200,),
                      RadioListTile<String>(
                          title: Text('English'),
                          value: 'en',
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value !=null){
                              setState(()=> _language = value);
                              Navigator.pop(context,'en');
                            }
                          }),

                      RadioListTile<String>(
                          title: Text('العربية'),
                          value: 'ar',
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value !=null){
                              setState(()=> _language = value);
                              Navigator.pop(context,'ar');
                            }
                          }),
                    ],

                  ),
                );
              });
            },
          );

        });
    if(langCode !=null){
      Future.delayed(const Duration(milliseconds: 500),(){
        Provider.of<LanguageProvider>(context , listen: false).changeLanguage();
      });
    }
  }
}

