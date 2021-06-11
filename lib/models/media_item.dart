import 'package:audio_service/audio_service.dart';

class ASMediaItem {
  final String path;
  final MediaItem item;

   ASMediaItem(String id, String album, String title, String path, Uri artUri) :
    this.path = path,
    this.item = MediaItem(id: id, album: album, title: title);

   Map<String, dynamic> toJson() {
      var json = this.item.toJson();
      json['path'] = this.path;
      return json;
  }

factory ASMediaItem.fromJson(Map raw) => ASMediaItem(raw['id'], raw['album'], raw['title'], raw['path'], raw['artUri']);

}