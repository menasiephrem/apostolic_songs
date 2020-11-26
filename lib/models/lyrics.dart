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
    albumId = json['albumId'];
}