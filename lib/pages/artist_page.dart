

import 'package:apostolic_songs/models/Artist.dart';
import 'package:apostolic_songs/models/album.dart';
import 'package:apostolic_songs/services/album_service.dart';
import 'package:apostolic_songs/widgets/album_card.dart';
import 'package:flutter/material.dart';

import '../finder.dart';


class ArtistPage extends StatefulWidget {
  ArtistPage(this.artist);

  final Artist artist;

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  AlbumService _albumServices = locator<AlbumService>();
  List<Album> artistAlbum;

  @override
  void initState() {
    super.initState();
    _getArtistAlbums();
  }

  _getArtistAlbums() async {
    var albums = await _albumServices.getArtistAlbums(context, this.widget.artist);
    setState(() {
      artistAlbum = albums;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(this.widget.artist.artistName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(this.widget.artist.albumCount > 1? "${this.widget.artist.albumCount} አልበሞች" : "1 አልበም", style: TextStyle(fontSize: 16))
        ],),
      ),
      body: artistAlbum != null?
        GridView.count(
          crossAxisCount: 2,
          children: artistAlbum.map<Widget>((e){
            return AlbumCard(e); 
          }).toList(),
        ): 
        Center(child: CircularProgressIndicator(),),
    );
  }
}