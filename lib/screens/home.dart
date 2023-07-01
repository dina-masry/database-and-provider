import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:database/provider/NoteProvider.dart';
import 'package:database/screens/Note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:database/extensions/context_extensions.dart';

import '../models/note.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
   Provider.of<NoteProvider>(context ,listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutConfirmDialog(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoteScreen()));
              },
              icon: const Icon(Icons.note_add_outlined))
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, NoteProvider value, child) {
          if (value.notes.isNotEmpty) {
            return ListView.builder(
                itemCount: value.notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: ()  {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteScreen(
                                note: value.notes[index],
                              )));

                    },
                    leading: const Icon(Icons.note),
                    title: Text(value.notes[index].title),
                    subtitle: Text(value.notes[index].info),
                    trailing: IconButton(
                        onPressed: ()  {
                          _delete(index);
                        },
                        icon: Icon(Icons.delete)),
                  );
                });
          } else {
            return Center(
              child: Text(
                'No Data',
                style: GoogleFonts.cairo(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
    );
  }
  void _delete(int index)async{

    ProcessResponse processResponse =
        await Provider.of<NoteProvider>(context,
        listen: false)
        .delete(index);
    if (processResponse.success) {
      context.showSnackBar(
          message: processResponse.message,
          error: !processResponse.success);
    }
  }

  void _showLogoutConfirmDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(width: 1.w, color: Colors.pink.shade200)),
            backgroundColor: Colors.pink.shade100,
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure?'),
            titleTextStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            contentTextStyle: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
              height: 1.0,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.cairo(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    SharedPrefController().clear();
                    Navigator.pop(context, true);
                    Navigator.pushReplacementNamed(context, '/Login');
                  },
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.cairo(color: Colors.blue),
                  ))
            ],
          );
        }

        );
    if (result ?? false) {
      bool cleared = await SharedPrefController().clear();
      if (cleared) {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

}
