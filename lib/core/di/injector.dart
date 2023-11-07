import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';

final injector = GetIt.instance;

void initCore() async {

  injector.registerSingleton<LocalDb>(LocalDbImpl());
  await injector.get<LocalDb>().initDb();

}

void provideDataSources() {

}

void provideRepositories() {

}

void provideUseCases() {

}

void provideBlocs() {

}