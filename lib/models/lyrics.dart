import 'package:audio_service/audio_service.dart';

class Lyrics {
  String id;
  String lyricTitle;
  String albumId;
  String lyricText;
  String lryicArtist;
  int trackNumber;

  Lyrics.fromJson(Map<String, dynamic> json, int id) : 
    id = "$id",
    lyricTitle = json['lyricTitle'],
    lyricText = json['lyricText'],
    albumId = json['albumId'],
    trackNumber = json['trackNumber'];

   Lyrics.fromMediaItem(MediaItem item) :
     id = item.id,
     lyricTitle = item.title,
     lryicArtist = item.album,
     lyricText = item.extras['lyricText'],
     albumId = item.extras['albumId'];

    
}