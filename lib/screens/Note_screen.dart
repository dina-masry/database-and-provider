import 'package:database/extensions/context_extensions.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:database/provider/NoteProvider.dart';
import 'package:database/widgets/appTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
class NoteScreen extends StatefulWidget {
   NoteScreen({Key? key , this.note}) : super(key: key);
  Note? note ;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController ;
  late TextEditingController _infoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _infoController = TextEditingController(text: widget.note?.info);
  }
  bool  get isNewNote => widget.note==null;
  String get title => isNewNote? context.localizations.create : context.localizations.update;
  @override
  void dispose() {
    // TODO: implement dispose
    _infoController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField( title: context.localizations.title, icon: Icons.note, textInputType: TextInputType.text, controller: _titleController,),
            SizedBox(height: 10.h,),
            AppTextField(title: context.localizations.info, icon: Icons.info, textInputType: TextInputType.text,controller:_infoController,),
            SizedBox(height: 20.h,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity , 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),

                ),
                onPressed: (){
                  _performSave();
                  },
                child:  Text(context.localizations.save))  ,

          ],
        ),
      ),
    );
  }
  void _performSave(){
    if(_checkData()) {
      _save();
    }
  }
  bool _checkData(){
    if(_titleController.text.isNotEmpty && _infoController.text.isNotEmpty){
      return true;
    }
    return false;
  }
  void _save()async{
    ProcessResponse processResponse = isNewNote ?
    await Provider.of<NoteProvider>(context , listen: false).create(note) :
    await Provider.of<NoteProvider>(context , listen: false).updateNote(note);

    if(processResponse.success){
      isNewNote? clear(): Navigator.pop(context);
      context.showSnackBar(message: processResponse.message, error: !processResponse.success);
    }
  }
  void clear(){
    _titleController.clear();
    _infoController.clear();
  }

  Note get note{
    Note note = isNewNote ?Note():widget.note!;
    note.title = _titleController.text;
    note.info = _infoController.text;
    note.user_id = SharedPrefController().getValueFor<int>(Prefkeys.id.name)!;
    return note;
  }





  }
