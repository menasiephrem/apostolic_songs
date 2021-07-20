import 'package:apostolic_songs/models/album.dart';
import 'package:apostolic_songs/pages/album_page.dart';
import 'package:flutter/material.dart';


class AlbumCard extends StatelessWidget {
  const AlbumCard(this.album);

  final Album album;

  @override
  Widget build(BuildContext context) {
    return
    InkWell(
      onTap: (){
         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlbumPage(album)),
              );
      },
      child:
        Container(
          padding: EdgeInsets.only(top: 10, left: 10, ),
            child: 
              Card(
                elevation: 6,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset('assets${album.albumArt}')
                ),
            ),
     );
  }
}