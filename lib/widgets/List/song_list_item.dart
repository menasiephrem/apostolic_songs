import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:flutter/material.dart';

import '../../finder.dart';

class LyricsListItem extends StatefulWidget {
  LyricsListItem(this.lyrics, this.callback);

  final Lyrics lyrics;
  final VoidCallback callback;

  @override
  _LyricsListItemState createState() => _LyricsListItemState();
}

class _LyricsListItemState extends State<LyricsListItem> {
    LyricsService _lyricsService = locator<LyricsService>();
    
    bool isFav = false;

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
    return 
    InkWell(
      onTap: this.widget.callback,
      child:
      Container(
        height: 40,
        child: 
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(this.widget.lyrics.id),
                  Text(this.widget.lyrics.lyricTitle),
                  InkWell(
                    child: isFav? Icon( Icons.favorite, color: Colors.amber,): Icon( Icons.favorite_border, color: Colors.amber,),
                    onTap: _setFav,
                  )
                ],
              ),
          )
      ),
  );
  }
}