
import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 0)
class Playlist extends HiveObject {

   @HiveField(0)
   String name;

   @HiveField(1)
   List<String> ids;

   @HiveField(2)
   DateTime createdAt;
}