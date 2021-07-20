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

    MediaItem toMediaItem(String downloadPath){
      String albumNumber = this.albumId.replaceAll(new RegExp(r'[^0-9]'),'');
      String albumName = this.albumId.toLowerCase().replaceAll(new RegExp(r'[^a-z]'),'');
      String fileLocation = "$downloadPath/$albumName/$albumNumber/" + "${this.trackNumber}.mp3";
      return MediaItem(
          id: this.id,
          album: this.lryicArtist, 
          title:this.lyricTitle, 
          extras: {
              'path': fileLocation,
              'albumId': this.albumId,
              'lyricText': this.lyricText
          }, 
          artUri: Uri.parse("https://res.cloudinary.com/evolunt/image/upload/c_thumb,w_200,g_face/v1623426697/albumArts/${this.albumId}.jpg".toLowerCase()));
    }
}