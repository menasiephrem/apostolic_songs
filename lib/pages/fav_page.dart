
import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/pages/lyrics_page.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:apostolic_songs/widgets/List/list_item.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../finder.dart';

class FavLyricsList extends StatefulWidget {
  FavLyricsList();

  @override
  _FavLyricsListState createState() => _FavLyricsListState();
}

class _FavLyricsListState extends State<FavLyricsList> {
  LyricsService _lyricsServices = locator<LyricsService>();
  List<Lyrics> favLyrics;
 
   @override
   void initState() { 
     super.initState();
     _loadFavLyrics();
   }

  _loadFavLyrics()async {
    var lyrics = await _lyricsServices.getFav(context);
    setState(() {
      favLyrics = lyrics;
    });
  } 

  _genrateSongListItem(BuildContext context) {
     return favLyrics
        .map<Widget>(
          (lyric) => 
            ListItem(lyric.lyricTitle, lyric.lryicArtist, "/images/${lyric.albumId}.jpg".toLowerCase(), () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AudioServiceWidget(child: LyricsPage(lyric))),
              ).then((value){
                _loadFavLyrics();
              })
            })
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child:
        favLyrics != null?
          favLyrics.length == 0 ?
          Center(child: Text("ምንም የተምረጡ መዝሙሮች የሉም 😔")):
          ListView(
            children: _genrateSongListItem(context),
          ): 
        Center(child: CircularProgressIndicator(),)
    );
  }
}