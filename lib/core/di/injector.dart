import 'package:get_it/get_it.dart';
import 'package:spotify_downloader/core/db/local_db.dart';
import 'package:spotify_downloader/core/db/local_db_impl.dart';

final injector = GetIt.instance;

void initCore() async {
  
  injector.registerSingleton<LocalDb>(LocalDbImpl());
  await injector<LocalDb>().initDb();

}