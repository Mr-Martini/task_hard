import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../note/domain/entities/note.dart';
import '../../domain/entities/tags.dart';

class TagsModel extends Equatable implements TagsEntity {
  final List<String> tags;
  final List<String> noteTags;
  final List<Note> noteList;

  TagsModel({
    @required this.tags,
    @required this.noteTags,
    @required this.noteList,
  });

  @override
  List<Object> get props => [tags, noteTags, noteList];

  factory TagsModel.fromIterable(
      Iterable<dynamic> tagsFromDB, dynamic noteMap, List<Note> notes) {
    List<String> aux = List<String>.from(noteMap['tags'] ?? <String>[]);
    return TagsModel(
      tags: List<String>.from(tagsFromDB ?? <String>[]),
      noteTags: aux,
      noteList: notes,
    );
  }
}
