import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../note/domain/entities/note.dart';
import '../entities/home_app_bar_entity.dart';
import '../repositories/home_app_bar_repository.dart';

class PutReminderAppBarUseCase
    implements UseCases<HomeAppBarEntity, PutReminderAppBarParams> {
  final HomeAppBarRepository repository;

  PutReminderAppBarUseCase({@required this.repository});

  @override
  Either<Failure, HomeAppBarEntity> call(PutReminderAppBarParams params) {
    return repository.putReminder(
        params.selectedNotes, params.scheduledDate, params.repeat);
  }
}

class PutReminderAppBarParams extends Equatable {
  final List<Note> selectedNotes;
  final DateTime scheduledDate;
  final String repeat;

  PutReminderAppBarParams(
      {@required this.selectedNotes,
      @required this.scheduledDate,
      @required this.repeat});

  @override
  List<Object> get props => [selectedNotes, scheduledDate, repeat];
}
