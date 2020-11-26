import 'album.dart';

class Artist {
  String id;
  String artistName;
  String artistPic;
  int albumCount;

  Artist.empty();

  Artist.formAlbum(Album album){
      this.artistName = album.albumArtist;
      this.id = album.albumId;
      this.albumCount = 1;
      this.artistPic = album.albumArt;
  }

  Artist.fromJson(Map<String, dynamic> json) : 
    id = json['id'],
    artistName = json['artistName'],
    albumCount = json['albumCount'],
    artistPic = json['artistPic'];
}