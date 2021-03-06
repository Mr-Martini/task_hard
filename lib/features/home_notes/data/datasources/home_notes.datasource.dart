import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../../controllers/reminder-controller/reminder-controller.dart';
import '../../../note/domain/entities/note.dart';
import '../model/home_notes_model.dart';

abstract class HomeNotesDataSource {
  HomeNotesModel getNotes();
  HomeNotesModel listen(Iterable<dynamic> notes);
  HomeNotesModel deleteEmptyNotes(Iterable<Note> notes);
  HomeNotesModel expireChecker(Iterable<dynamic> notes);
}

class HomeNotesDataSourceImpl implements HomeNotesDataSource {
  final Box<dynamic> homeNotesBox;

  HomeNotesDataSourceImpl({
    @required this.homeNotesBox,
  });

  @override
  HomeNotesModel getNotes() {
    final iterable = homeNotesBox.values;
    return HomeNotesModel.fromIterable(iterable);
  }

  @override
  HomeNotesModel listen(Iterable notes) {
    return HomeNotesModel.fromIterable(notes);
  }

  @override
  HomeNotesModel expireChecker(Iterable notes) {
    for (var note in notes) {
      var aux = note;
      aux['expired'] = true;
      homeNotesBox.put(aux['key'], aux);
    }
    return HomeNotesModel.fromIterable(notes);
  }

  @override
  HomeNotesModel deleteEmptyNotes(Iterable<Note> notes) {
    for (Note note in notes) {
      homeNotesBox.delete(note.key);
      ReminderController.cancel(note.reminderKey ?? note.key.hashCode);
    }
    return HomeNotesModel.fromIterable(homeNotesBox.values);
  }
}
