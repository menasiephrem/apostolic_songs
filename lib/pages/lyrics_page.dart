import 'dart:io';

import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../finder.dart';


class LyricsPage extends StatefulWidget {
  LyricsPage(this.lyrics);
  final Lyrics lyrics;
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  LyricsService _lyricsService = locator<LyricsService>();

  bool isFav = false;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  Lyrics lyrics;
  bool loading = false;

    @override
    void initState() { 
      super.initState();
      setState(() {
        lyrics = this.widget.lyrics;
      });
      _isFav();
      _getScaleConfig();
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

    _updateScaleFactor(double scale){
       setState(() {
          _scaleFactor = _baseScaleFactor * scale;
      });
      _saveScaleConfig(scale);
    }

    _saveScaleConfig(double scale) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('font', _scaleFactor);
    }

     _getScaleConfig() async {
      final prefs = await SharedPreferences.getInstance();
      double scale = prefs.getDouble('font');
      setState(() {
        _scaleFactor = scale == null? 1 : scale;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Column(
          crossAxisAlignment: Platform.isAndroid? CrossAxisAlignment.start: CrossAxisAlignment.center,
          children: [
            Text(lyrics.lyricTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(lyrics.lryicArtist, style: TextStyle(fontSize: 16))
        ],),
      ),
      body:
      loading? Center(child: CircularProgressIndicator(),):
      Container(
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
                    _updateScaleFactor(details.scale);
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