
import 'dart:convert';

import 'package:apostolic_songs/models/lyrics.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LyricsService {

    Future<List<Lyrics>> getAllLyric(BuildContext context) async{
      List<Lyrics> fromJson = List();
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
      List<Lyrics> ret = List();
      for(int i = 0; i < albumLyrcs.length; i++){
        var l = albumLyrcs[i];
        l.trackNumber = i + 1;
        ret.add(l);
      }
      return ret;
    }

    setFav(Lyrics lyrics, bool isFaV) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("${lyrics.id}", isFaV);
      return isFaV;
    }

    Future<bool> isFav(Lyrics lyrics) async {
      final prefs = await SharedPreferences.getInstance();
      var fav = prefs.get("${lyrics.id}");
      return fav == null? false : fav;
    }

    Future<List<Lyrics>> getFav() async {

    }
  
  }