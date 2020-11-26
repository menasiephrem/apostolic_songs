import 'package:apostolic_songs/models/Artist.dart';
import 'package:apostolic_songs/pages/artist_page.dart';
import 'package:apostolic_songs/services/album_service.dart';
import 'package:apostolic_songs/widgets/List/list_item.dart';
import 'package:flutter/material.dart';

import '../finder.dart';

class SoloAlbumsList extends StatefulWidget {
  SoloAlbumsList({Key key}) : super(key: key);

  @override
  _SoloAlbumsListState createState() => _SoloAlbumsListState();
}

class _SoloAlbumsListState extends State<SoloAlbumsList> {
  AlbumService _albumServices = locator<AlbumService>();
  List<Artist> soloArtists;
 
   @override
   void initState() { 
     super.initState();
     _loadSoloAlbums();
   }

  _loadSoloAlbums()async {
    var artists = await _albumServices.getSoloArtists(context);
    setState(() {
      soloArtists = artists;
    });
  } 

  _genrateSongListItem(BuildContext context) {
     return soloArtists
        .map<Widget>(
          (artist) => 
            ListItem(artist.artistName, artist.albumCount > 1? "${artist.albumCount} አልበሞች" : "1 አልበም", artist.artistPic, () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArtistPage(artist)),
              )
            })
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child:
        soloArtists != null?
          ListView(
            children: _genrateSongListItem(context),
          ): 
        Center(child: CircularProgressIndicator(),)
    );
  }
}