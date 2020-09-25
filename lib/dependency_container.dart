import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:task_hard/features/note/domain/usecases/archive_note_usecase.dart';

import './features/time_preference/domain/usecases/time_preference_usecase_night.dart';
import './features/time_preference/domain/usecases/time_preference_usecase_set_afternoon.dart';
import 'features/home_notes/data/datasources/home_notes.datasource.dart';
import 'features/home_notes/data/repositories/home_notes_repository_impl.dart';
import 'features/home_notes/domain/repositories/home_notes_repository.dart';
import 'features/home_notes/domain/usecases/get_notes_usecase.dart';
import 'features/home_notes/domain/usecases/listen_notes_usecase.dart';
import 'features/home_notes/presentation/bloc/homenotes_bloc.dart';
import 'features/note/data/datasources/note_local_data_source.dart';
import 'features/note/data/repositories/note_repository_impl.dart';
import 'features/note/domain/repositories/note_repository.dart';
import 'features/note/domain/usecases/copy_note_usecase.dart';
import 'features/note/domain/usecases/delete_note.dart';
import 'features/note/domain/usecases/delete_note_reminder_usecase.dart';
import 'features/note/domain/usecases/get_note_by_key_usecase.dart';
import 'features/note/domain/usecases/write_note_color_usecase.dart';
import 'features/note/domain/usecases/write_note_content_usecase.dart';
import 'features/note/domain/usecases/write_note_reminder_usecase.dart';
import 'features/note/domain/usecases/write_note_title_usecase.dart';
import 'features/note/presentation/bloc/note_bloc.dart';
import 'features/taged_notes_home/data/datasources/taged_notes_home_local_data_source.dart';
import 'features/taged_notes_home/data/repositories/taged_notes_home_repository_impl.dart';
import 'features/taged_notes_home/domain/repositories/taged_notes_home_repository.dart';
import 'features/taged_notes_home/domain/usecases/taged_notes_home_get_preference.dart';
import 'features/taged_notes_home/domain/usecases/taged_notes_home_set_preferences.dart';
import 'features/taged_notes_home/presentation/bloc/tagednoteshomebloc_bloc.dart';
import 'features/theme/data/datasources/theme_local_data_source.dart';
import 'features/theme/data/repositories/theme_repository_impl.dart';
import 'features/theme/domain/repositories/theme_repository.dart';
import 'features/theme/domain/usecases/theme_get_theme_data_usecase.dart';
import 'features/theme/domain/usecases/theme_set_theme.dart';
import 'features/theme/domain/usecases/theme_set_theme_main_color.dart';
import 'features/theme/presentation/bloc/theme_bloc.dart';
import 'features/time_preference/data/datasources/time_preference_local_data_source.dart';
import 'features/time_preference/data/repositories/time_preference_local_data_source_repository.dart';
import 'features/time_preference/domain/repositories/time_preference_repository.dart';
import 'features/time_preference/domain/usecases/time_preference_usecase_morning.dart';
import 'features/time_preference/domain/usecases/time_preference_usecase_set_noon.dart';
import 'features/time_preference/domain/usecases/time_preference_usecase_set_preference_morning.dart';
import 'features/time_preference/presentation/bloc/timepreference_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  List<int> key = await getEncKey();
  await registerHomeNotes(key);
  await registerTagedNotesHome();
  await registerTimePreference();
  await registerTheme();
  await registerNote(key);
}

Future<void> registerHomeNotes(List key) async {
  //Home notes bloc
  sl.registerFactory(
    () => HomenotesBloc(
      getNotes: sl(),
      listenNotes: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(
    () => GetNotesUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ListenNotesUseCase(
      repository: sl(),
    ),
  );

  //repositories
  sl.registerLazySingleton<HomeNotesRepository>(
    () => HomeNotesRepositoryImpl(
      dataSource: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<HomeNotesDataSource>(
    () => HomeNotesDataSourceImpl(
      homeNotesBox: sl.get(instanceName: 'home_notes'),
    ),
  );

  //external
  sl.registerSingletonAsync(
    () async => await Hive.openBox('notes', encryptionKey: key),
    instanceName: 'home_notes',
  );
}

Future<void> registerNote(List key) async {
  //Bloc Note
  sl.registerFactory(
    () => NoteBloc(
      getNote: sl(),
      writeContent: sl(),
      writeTitle: sl(),
      writeColor: sl(),
      writeReminder: sl(),
      deleteReminder: sl(),
      deleteNote: sl(),
      archiveNote: sl(),
      copyNote: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(
    () => GetNoteByKeyUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => WriteNoteContentUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => WriteNoteTitletUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => WriteNoteColorUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => WriteNoteReminderUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteNoteReminderUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteNoteUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ArchiveNoteUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CopyNoteUseCase(
      repository: sl(),
    ),
  );

  //repositories
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      dataSource: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(
      noteBox: sl.get(instanceName: 'notes'),
    ),
  );

  //external
  sl.registerSingletonAsync(
    () async => await Hive.openBox('notes', encryptionKey: key),
    instanceName: 'notes',
  );
}

Future<void> registerTimePreference() async {
  //Bloc TimePreference
  sl.registerLazySingleton(
    () => TimepreferenceBloc(
      getTime: sl(),
      setMorning: sl(),
      setNoon: sl(),
      setAfternoon: sl(),
      setNight: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(
    () => GetTimePreferenceUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetMorningTimePreferenceUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetNoonTimePreferenceUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetAfternoonTimePreferenceUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetNightTimePreferenceUseCase(
      sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<TimePreferenceRepository>(
    () => TimePreferenceLocalDataSoureceRepositoryImpl(
      dataSource: sl(),
    ),
  );

  //dataSources
  sl.registerLazySingleton<TimePreferenceLocalDataSource>(
    () => TimePreferenceLocalDataSourceImpl(
      timePreferenceBox: sl.get(instanceName: 'time_preferences'),
    ),
  );

  //external
  sl.registerSingletonAsync(
    () async => await Hive.openBox('time_preferences'),
    instanceName: 'time_preferences',
  );
}

Future<void> registerTheme() async {
  //Bloc theme
  sl.registerLazySingleton(
    () => ThemeBloc(
      getTheme: sl(),
      setTheme: sl(),
      setColor: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(
    () => GetThemeDataUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetThemeUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetMainColorUseCase(
      sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(
      themeBox: sl.get(instanceName: 'theme_preferences'),
    ),
  );

  //external
  sl.registerSingletonAsync(
    () async => await Hive.openBox('theme_preferences'),
    instanceName: 'theme_preferences',
  );
}

Future<void> registerTagedNotesHome() async {
//Bloc taged notes home
  sl.registerLazySingleton(
    () => TagednoteshomeblocBloc(
      getPreference: sl(),
      setPreference: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(
    () => GetTagedNotesHomePreference(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetTagedNotesPreference(
      sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<TagedNotesHomeRepository>(
    () => TagedNotesHomeRepositoryImpl(
      sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<TagedNotesHomeLocalDataSource>(
    () => TagedNotesHomeLocalDataSourceImpl(
      sl.get(instanceName: 'settings_preferences'),
    ),
  );

  sl.registerSingletonAsync(
    () async => await Hive.openBox('settings_preferences'),
    instanceName: 'settings_preferences',
  );
}

Future<List> getEncKey() async {
  FlutterSecureStorage storage = FlutterSecureStorage();

  String keyAsString = await storage.read(key: 'key');

  List<int> key = [];

  if (keyAsString == null) {
    key = Hive.generateSecureKey();
    String encKey = jsonEncode(key);
    await storage.write(key: 'key', value: encKey);
    return key;
  }
  return key = List<int>.from(jsonDecode(keyAsString));
}