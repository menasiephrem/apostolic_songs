import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/models/playlist.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../finder.dart';
import '../theme_changer.dart';

class PlaylistItem extends StatefulWidget {
  PlaylistItem(this.playlist);

  final Playlist playlist;
  @override
  _PlaylistItemState createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  LyricsService _lyricsService = locator<LyricsService>();

  String imageAdress = ""; 
  List<Lyrics> lyrics = [];

  @override
  void initState() { 
    super.initState();
    _loadLyrics();
  }

  _loadLyrics() async {
    var _lyrics = await _lyricsService.getLyricsFromIds(context, widget.playlist.ids);
    setState(() {
      lyrics = _lyrics;
      imageAdress = "/images/${_lyrics[0].albumId}.jpg".toLowerCase();
    });
  } 
  
  _buildAvater(String imagAddress){
    return  CircleAvatar(
              backgroundImage: AssetImage('assets$imagAddress'),
              radius: 27.0,
            );
  }

  @override
  Widget build(BuildContext context) {

    var _themeProvider = Provider.of<ThemeChanger>(context);
    ThemeData mode = _themeProvider.getTheme;
    return Container(
       child: InkWell(
         child: Container(
           child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 6.0, top: 2.0),
                      child: imageAdress == "" ? Text("") : _buildAvater(imageAdress),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.playlist.name.length > 20 ?
                            widget.playlist.name.substring(0, 20): widget.playlist.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          Container(
                            margin: EdgeInsets.only(top: 2.0),
                            child: Text("${widget.playlist.ids.length} መዝሙሮች",
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:20.0),
                      child: Text(DateFormat('yyyy-MM-dd').format(widget.playlist.createdAt)),
                    ),
                    Padding( padding: const EdgeInsets.only(top: 3.0), ),
                    Padding( padding: const EdgeInsets.only(left: 65.0), child: 
                      Divider(color: Colors.grey[ mode.brightness == Brightness.dark ? 700: 400 ], height: 2,)
                    ),
                  ],
                  
                ),
         )
       ),
    );
  }
}
