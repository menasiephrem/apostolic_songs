class Album {
  String albumId;
  String albumTitle;
  String albumArtist;
  String albumArt;
  String isSolo;

  Album.fromJson(Map<String, dynamic> json) : 
    albumId = json['albumId'],
    albumTitle = json['albumTitle'],
    albumArt = json['albumArt'],
    albumArtist = json['albumArtist'],
    isSolo = json['isSolo'];
}