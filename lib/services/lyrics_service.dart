
import 'dart:convert';

import 'package:apostolic_songs/models/album.dart';
import 'package:apostolic_songs/models/lyrics.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LyricsService {

  Future<List<Album>> _getAlbums(BuildContext context) async{
    List<Album> fromJson = [];
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/Album.json");
        var albumsJson = json.decode(value);   
        for(var album in albumsJson){
          fromJson.add(Album.fromJson(album));
        }
    return fromJson;
  }

    Future<List<Lyrics>> getAllLyric(BuildContext context) async{
      List<Lyrics> fromJson = [];
      var value = await DefaultAssetBundle.of(context)
          .loadString("data/Lyrics.json");
          var lyricJson = json.decode(value);   
          for(int i = 0; i<lyricJson.length; i++){
            var lyric = lyricJson[i];
            fromJson.add(Lyrics.fromJson(lyric, i));
          }
      return fromJson;
    }

    Future<List<Lyrics>> getAlbumLyric(BuildContext context, String albumId) async{
      List<Lyrics> allLyrics = await getAllLyric(context);
      var albumLyrcs = allLyrics.where((lyric) => lyric.albumId == albumId ).toList();
      List<Lyrics> ret = [];
      for(int i = 0; i < albumLyrcs.length; i++){
        var l = albumLyrcs[i];
        l.trackNumber = i + 1;
        ret.add(l);
      }
      return ret;
    }

    setFav(Lyrics lyrics, bool isFaV) async {
      final prefs = await SharedPreferences.getInstance();
      if(isFaV){
        await prefs.setBool("${lyrics.id}", isFaV);
      }else{
        await prefs.remove("${lyrics.id}");
      }
      return isFaV;
    }

    Future<bool> isFav(Lyrics lyrics) async {
      final prefs = await SharedPreferences.getInstance();
      var fav = prefs.get("${lyrics.id}");
      return fav == null? false : fav;
    }

    Future<List<Lyrics>> getFav(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> lyricsInPref = prefs.getKeys().toList();

      lyricsInPref.removeWhere((st) => st == "theme");
      lyricsInPref.removeWhere((st) => st == "font");

      return await getLyricsFromIds(context, lyricsInPref);
    }

    Future<List<Lyrics>> getLyricsFromIds(BuildContext context, List<String> ids)async{
      List<Lyrics> fav = [];
      
      List<Lyrics> allLyrics = await getAllLyric(context);
      List<Album> allAlbums = await _getAlbums(context);

      for(String key in ids){
        var lyric = allLyrics.firstWhere((l) => l.id == key);
        if(lyric != null){
          var album = allAlbums.firstWhere((a) => a.albumId == lyric.albumId);
          lyric.lryicArtist = album.albumArtist;
          fav.add((lyric));
        }
      }
      return fav;
    }

    Future<List<Lyrics>> searchLyrics(BuildContext context, String query) async {
      List<Lyrics> ret = [];
      var regex = RegExp(r''+ query, caseSensitive: false);
      var allAlbums = await _getAlbums(context);
      List<Lyrics> allLyrics = await getAllLyric(context);
      var serachLyris =  allLyrics.where((l) => l.lyricTitle.contains(regex)).toList();

      for(Lyrics lyric in serachLyris){
          var album = allAlbums.firstWhere((a) => a.albumId == lyric.albumId);
          lyric.lryicArtist = album.albumArtist;
          ret.add((lyric));
      }

      return ret;
    }

    Future<Lyrics> loadLyrics(BuildContext context, String id) async {
      print(id);
      var allAlbums = await _getAlbums(context);
      List<Lyrics> allLyrics = await getAllLyric(context);
      var lyric = allLyrics.firstWhere((l) => l.id == "$id");
      var album = allAlbums.firstWhere((a) => a.albumId == lyric.albumId);
      lyric.lryicArtist = album.albumArtist;
      return lyric;
    }
  
  }