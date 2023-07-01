import 'package:database/prefs/shared_pref_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class Launch extends StatefulWidget {
  const Launch({Key? key}) : super(key: key);

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1),(){
      String route = SharedPrefController().loggedIn ?'/home':'/Login';
      Navigator.pushReplacementNamed(context, route);
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.pink.shade100,
                  Colors.blue.shade100
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd
            )
        ),
        child: Text('Data App' , style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 30.sp,
            letterSpacing: 5.w,
            color: Colors.white
        ),),
      ),
    );
  }
}

