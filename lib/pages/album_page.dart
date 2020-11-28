import 'dart:io';

import 'package:apostolic_songs/models/album.dart';
import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:apostolic_songs/widgets/List/song_list_item.dart';
import 'package:flutter/material.dart';

import '../finder.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage(this.album);

  final Album album;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  LyricsService _lyricsService = locator<LyricsService>();
  List<Lyrics> allLyrics;

    @override
    void initState() { 
      super.initState();
      _loadLyrics();
    }

    _loadLyrics() async {
      setState(() {
        allLyrics = null;
      });
      var lyrics = await _lyricsService.getAlbumLyric(context, this.widget.album.albumId);
      setState(() {
        allLyrics = lyrics;
      });
    }

    _genrateSongListItem(BuildContext context) {
      return allLyrics
              .map<Widget>(
                (lyrics){
                  lyrics.lryicArtist = this.widget.album.albumArtist;
                  return LyricsListItem(lyrics);
                }
              )
              .toList();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: Platform.isAndroid? CrossAxisAlignment.start: CrossAxisAlignment.center,
          children: [
            Text(this.widget.album.albumTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(this.widget.album.albumArtist, style: TextStyle(fontSize: 16))
        ],),
      ),
      body: 
      Container(
        width: MediaQuery.of(context).size.width,
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child:  Container(
                    child: Image.asset('assets${this.widget.album.albumArt}'),
                ),
                radius: 150.0,
              ),
              SizedBox(height: 15,),
              allLyrics == null?
              Center(child: CircularProgressIndicator(),):
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView(
                      children: _genrateSongListItem(context),
                  ),
                ),
              ), 
            ],
        ),
      ), 
    );
  }
}