import 'package:apostolic_songs/models/album.dart';
import 'package:apostolic_songs/pages/album_page.dart';
import 'package:apostolic_songs/services/album_service.dart';
import 'package:apostolic_songs/widgets/List/list_item.dart';
import 'package:flutter/material.dart';

import '../finder.dart';

class ChoirAlbumsList extends StatefulWidget {
  ChoirAlbumsList();

  @override
  _ChoirAlbumsListState createState() => _ChoirAlbumsListState();
}

class _ChoirAlbumsListState extends State<ChoirAlbumsList> {
  AlbumService _albumServices = locator<AlbumService>();
  List<Album> choirALbums;
 
   @override
   void initState() { 
     super.initState();
     _loadchoirAlbums();
   }

  _loadchoirAlbums()async {
    var albums = await _albumServices.getSoloOrChorAlbums(context, false);
    setState(() {
      choirALbums = albums;
    });
  } 

  _genrateSongListItem(BuildContext context) {
     return choirALbums
        .map<Widget>(
          (album) => 
            ListItem(album.albumTitle, album.albumArtist, album.albumArt, () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlbumPage(album)),
              )
            })
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child:
        choirALbums != null?
          ListView(
            children: _genrateSongListItem(context),
          ): 
        Center(child: CircularProgressIndicator(),)
    );
  }
}