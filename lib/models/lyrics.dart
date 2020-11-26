class Lyrics {
  String id;
  String lyricTitle;
  String albumId;
  String lyricText;

  Lyrics.fromJson(Map<String, dynamic> json) : 
    id = json['id'],
    lyricTitle = json['lyricTitle'],
    lyricText = json['lyricText'],
    albumId = json['albumId'];
}