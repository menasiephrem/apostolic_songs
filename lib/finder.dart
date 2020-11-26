import 'package:apostolic_songs/services/album_service.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupFinder() {
  locator.registerLazySingleton(() => AlbumService());
  locator.registerLazySingleton(() => LyricsService());
}