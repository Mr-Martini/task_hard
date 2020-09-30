import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../note/domain/entities/note.dart';
import '../entities/home_app_bar_entity.dart';
import '../repositories/home_app_bar_repository.dart';

class UndoArchiveAppBarUseCase
    implements UseCases<HomeAppBarEntity, UndoArchiveAppBarParams> {
  final HomeAppBarRepository repository;

  UndoArchiveAppBarUseCase({@required this.repository});

  @override
  Either<Failure, HomeAppBarEntity> call(UndoArchiveAppBarParams params) {
    return repository.undoArchive(params.selectedNotes);
  }
}

class UndoArchiveAppBarParams extends Equatable {
  final List<Note> selectedNotes;

  UndoArchiveAppBarParams({@required this.selectedNotes});

  @override
  List<Object> get props => [selectedNotes];
}