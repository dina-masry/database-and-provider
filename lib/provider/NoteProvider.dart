import 'package:database/database/note_db_controller.dart';
import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../process_response.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> notes = <Note>[];
  final NoteDbController _dbController = NoteDbController();

  Future<ProcessResponse> create(Note note) async {
    int newRowId = await _dbController.create(note);
    if (newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      notifyListeners();
    }
    return getResponse(success: newRowId != 0);
  }

  ProcessResponse getResponse({required bool success}) {
    return ProcessResponse(
        message:
            success ? 'Operation completed successfully' : 'Operation failed',
        success: success);
  }

  void read() async {
    notes = await _dbController.read();
    notifyListeners();
  }

  Future<ProcessResponse> updateNote(Note note) async {
    bool updated = await _dbController.update(note);
    if (updated) {
      int index = notes.indexWhere((element) => element.id == note.id);
      if (index != -1) {
        notes[index] = note;
        notifyListeners();
      }
    }
    return getResponse(success: updated);
  }

  Future<ProcessResponse> delete(int index) async {
    bool deleted = await _dbController.delete(notes[index].id);
    if (deleted) {
      notes.removeAt(index);
      notifyListeners();
    }
    return getResponse(success: deleted);
  }
}
