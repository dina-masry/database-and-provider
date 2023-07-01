import 'package:database/database/db_operations.dart';
import 'package:database/models/note.dart';
import 'package:database/prefs/shared_pref_controller.dart';

class NoteDbController extends DbOperations<Note>{
  @override
  Future<int> create(Note note) async{
    int newRowId = await database.rawInsert('INSERT INTO notes (title ,info , user_id)VALUES(?,?,?)',
        [note.title,note.info, note.user_id]);
    return newRowId;
  }

  @override
  Future<bool> delete(int id)async {
    int userId = SharedPrefController().getValueFor<int>(Prefkeys.id.name)!;

    int countOfDeletedRows = await database.rawDelete('DELETE FROM notes WHERE id =? AND user_id =?' , [id , userId]);
    return countOfDeletedRows ==1;
  }

  @override
  Future<List<Note>> read() async{
    int userId = SharedPrefController().getValueFor<int>(Prefkeys.id.name)!;
    List<Map<String, dynamic>> rowsMap = await database.query(Note.tableName , where: 'user_id =?' , whereArgs: [userId]);
    return rowsMap.map((rowMap) => Note.fromMap(rowMap)).toList();
  }

  @override
  Future<Note?> show(int id) async {
    List<Map<String , dynamic>> rowMap = await database.query(Note.tableName , where: 'id = ?' , whereArgs: [id]);
    return rowMap.isNotEmpty ? Note.fromMap(rowMap.first):null;

  }

  @override
  Future<bool> update(Note note) async{
    int userId = SharedPrefController().getValueFor<int>(Prefkeys.id.name)!;
    int countOfUpdatedRows = await database.rawUpdate('UPDATE notes SET title =? And info =? WHERE id =? AND user_id =?',
        [note.title , note.info ,note.id, userId] );
    return countOfUpdatedRows ==1;
  }

}