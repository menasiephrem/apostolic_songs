import 'dart:convert';
import 'package:apostolic_songs/models/Artist.dart';
import 'package:apostolic_songs/models/album.dart';
import 'package:flutter/material.dart';


class AlbumService {


  Future<List<Album>> getAlbums(BuildContext context) async{
    List<Album> fromJson = List();
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/Album.json");
        var albumsJson = json.decode(value);   
        for(var album in albumsJson){
          fromJson.add(Album.fromJson(album));
        }
    return fromJson;
  }

  Future<List<Album>> getSoloOrChorAlbums(BuildContext context, bool solo) async {
      List<Album> allAlbums = await getAlbums(context);
      return allAlbums.where((album) => album.isSolo == (solo ? "1": "0")).toList();
  }

   Future<List<Album>> getArtistAlbums(BuildContext context, Artist artist) async {
      List<Album> allAlbums = await getAlbums(context);
      return allAlbums.where((album) => album.albumArtist == artist.artistName).toList();
  }

  Future<List<Artist>> getSoloArtists(BuildContext context) async {
    List<Artist> ret = List();
    List<Album> allAlbums = await getSoloOrChorAlbums(context, true);
    Map<String, Artist> map = Map();
    allAlbums.forEach((album) {
      if(map.containsKey(album.albumArtist)){
        Artist artist = map[album.albumArtist];
        artist.albumCount = artist.albumCount + 1;
        artist.artistPic = album.albumArt;
        map[album.albumArtist] = artist;
      }else{
        var artist = Artist.formAlbum(album);
        map[album.albumArtist] = artist;
      }
    });

    map.forEach((_, value) {
      ret.add(value);
    });

    ret.sort((a, b) => a.id.compareTo(b.id));
    return ret;
  }


}