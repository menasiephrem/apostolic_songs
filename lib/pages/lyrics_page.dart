import 'dart:io';

import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:flutter/material.dart';

import '../finder.dart';


class LyricsPage extends StatefulWidget {
  LyricsPage(this.lyrics, this.artist);
  final Lyrics lyrics;
  final String artist;
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  LyricsService _lyricsService = locator<LyricsService>();

  bool isFav = false;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

    @override
    void initState() { 
      super.initState();
      _isFav();
    }

    _isFav() async {
      bool fav = await _lyricsService.isFav(this.widget.lyrics);
      setState(() {
        isFav = fav;
      });
   }

    _setFav() async{
      await _lyricsService.setFav(this.widget.lyrics, !isFav);
      setState(() {
        isFav = !isFav;
      });
    }
  
  @override
  Widget build(BuildContext context) {
    final lyrics = widget.lyrics;
    return Scaffold(
      appBar: AppBar(
       title: Column(
          crossAxisAlignment: Platform.isAndroid? CrossAxisAlignment.start: CrossAxisAlignment.center,
          children: [
            Text(lyrics.lyricTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(this.widget.artist, style: TextStyle(fontSize: 16))
        ],),
      ),
      body:Container(
       alignment: Alignment.topCenter,
       padding: EdgeInsets.only(top: 16),
       child: Flex(
         direction: Axis.vertical,
         children: [
            Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: GestureDetector(
                  onScaleStart: (details) {
                    _baseScaleFactor = _scaleFactor;
                  },
                  onScaleUpdate: (details) {
                     if (details.focalPoint.dx > 0) {
                      print("Right");
                    } else {
                      print("left");
                    }
                     setState(() {
                      _scaleFactor = _baseScaleFactor * details.scale;
                    });
                  },
                  child: Text(lyrics.lyricText, textAlign: TextAlign.center, textScaleFactor: _scaleFactor, ),
                ),
              ),
            ),
       ],) 
    ),
    floatingActionButton: new FloatingActionButton(
      elevation: 0.0,
      child: isFav?  Icon(Icons.favorite, color: Colors.red[400],) : Icon(Icons.favorite_border),
      backgroundColor: Colors.orange[100],
      onPressed: (){
       _setFav();
      }
    )
    );
  }
}