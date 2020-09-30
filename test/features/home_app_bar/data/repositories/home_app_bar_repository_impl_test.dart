import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_hard/controllers/repeat-controller/repeat-controller.dart';
import 'package:task_hard/features/home_app_bar/data/datasources/home_app_local_data_source.dart';
import 'package:task_hard/features/home_app_bar/data/model/home_app_bar_model.dart';
import 'package:task_hard/features/home_app_bar/data/repositories/home_app_bar_repository_impl.dart';
import 'package:task_hard/features/note/domain/entities/note.dart';

class MockLocalDataSource extends Mock implements HomeAppBarLocalDataSource {}

void main() {
  MockLocalDataSource dataSource;
  HomeAppBarRepositoryImpl impl;

  setUp(
    () {
      dataSource = MockLocalDataSource();
      impl = HomeAppBarRepositoryImpl(dataSource: dataSource);
    },
  );
  final selectedNotes = <Note>[];

  final model = HomeAppBarModel.fromList(selectedNotes);

  test(
    'should return HomeAppBarModel when addNote is called',
    () {
      when(dataSource.addNote(any)).thenReturn(model);

      final result = impl.addNote(selectedNotes);

      verify(dataSource.addNote(selectedNotes));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(model));
    },
  );

  final List<Note> notes = <Note>[
    Note(
      key: 'key',
      title: 'title',
      note: 'note',
      color: Color(Colors.pink.value),
      reminder: null,
      reminderKey: 'key'.hashCode,
      tags: [],
      lastEdited: null,
      repeat: null,
      expired: false,
    ),
  ];

  final modelForChangeColor = HomeAppBarModel.fromList(notes);

  test(
    'should return HomeAppBarModel with the specified color on each note',
    () {
      when(dataSource.changeColor(any, any)).thenReturn(modelForChangeColor);

      final result = impl.changeColor(Colors.pink, notes);

      verify(dataSource.changeColor(notes, Colors.pink));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForChangeColor));
    },
  );

  final modelForDelete = HomeAppBarModel.fromList(<Note>[]);

  test(
    'should return HomeAppBarEntity with no notes when deleteNote is called',
    () {
      when(dataSource.deleteNotes(any)).thenReturn(modelForDelete);

      final result = impl.deleteNotes(<Note>[]);

      verify(dataSource.deleteNotes(<Note>[]));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForDelete));
    },
  );

  final noteForUndoDelete = Note(
    key: 'key',
    title: 'title',
    note: 'note',
    color: Color(Colors.pink.value),
    reminder: null,
    reminderKey: 'key'.hashCode,
    tags: [],
    lastEdited: null,
    repeat: null,
    expired: null,
  );

  final modelForUndoDelete = HomeAppBarModel.fromList(<Note>[
    noteForUndoDelete,
  ]);

  test(
    '''should return HomeAppBarEntity with the 
    specified notes when undoDelete is called''',
    () {
      when(dataSource.undoDeleteNotes(any)).thenReturn(modelForUndoDelete);

      final result = impl.undoDelete(<Note>[noteForUndoDelete]);

      verify(dataSource.undoDeleteNotes(<Note>[noteForUndoDelete]));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForUndoDelete));
    },
  );

  final noteForArchiveNotes = Note(
    key: 'key',
    title: 'title',
    note: 'note',
    color: Color(Colors.pink.value),
    reminder: null,
    reminderKey: 'key'.hashCode,
    tags: [],
    lastEdited: null,
    repeat: null,
    expired: null,
  );

  final modelForArchiveNotes = HomeAppBarModel.fromList(<Note>[
    noteForUndoDelete,
  ]);

  test(
    'should return a empty instance of HomeAppBarEntity when archiveNote is called',
    () {
      when(dataSource.archiveNotes(any)).thenReturn(modelForArchiveNotes);

      final result = impl.archiveNotes(<Note>[noteForArchiveNotes]);

      verify(dataSource.archiveNotes(<Note>[noteForArchiveNotes]));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForArchiveNotes));
    },
  );

  final noteForUndoArchiveNotes = Note(
    key: 'key',
    title: 'title',
    note: 'note',
    color: Color(Colors.pink.value),
    reminder: null,
    reminderKey: 'key'.hashCode,
    tags: [],
    lastEdited: null,
    repeat: null,
    expired: null,
  );

  final modelForUndoArchiveNotes = HomeAppBarModel.fromList(<Note>[
    noteForUndoDelete,
  ]);

  test(
    '''should return HomeAppBarEntity with the 
    specified notes when undoArchive is called''',
    () {
      when(dataSource.undoArchiveNotes(any))
          .thenReturn(modelForUndoArchiveNotes);

      final result = impl.undoArchive(<Note>[noteForUndoArchiveNotes]);

      verify(dataSource.undoArchiveNotes(<Note>[noteForUndoArchiveNotes]));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForUndoArchiveNotes));
    },
  );

  final reminder = DateTime.now();
  final repeat = Repeat.NO_REPEAT;

  final noteForPutReminder = Note(
    key: 'key',
    title: 'title',
    note: 'note',
    color: Color(Colors.pink.value),
    reminder: reminder,
    reminderKey: 'key'.hashCode,
    tags: [],
    lastEdited: null,
    repeat: repeat,
    expired: null,
  );

  final modelForPutReminder = HomeAppBarModel.fromList(<Note>[
    noteForUndoDelete,
  ]);

  test(
    '''should return HomeAppBarEntity with the 
    specified notes when putReminder is called''',
    () {
      when(dataSource.putReminder(any, any, any))
          .thenReturn(modelForPutReminder);

      final result =
          impl.putReminder(<Note>[noteForPutReminder], reminder, repeat);

      verify(
          dataSource.putReminder(<Note>[noteForPutReminder], reminder, repeat));
      verifyNoMoreInteractions(dataSource);
      expect(result, Right(modelForPutReminder));
    },
  );
}
