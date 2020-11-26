import 'dart:io';

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
          padding: EdgeInsets.only(top: 10),
            child: 
              Card(
                elevation: 6,
                child: 
                  Column(
                    children: [
                      SizedBox(height: 2,),
                      CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child:  Container(
                              child: Image.asset('assets${album.albumArt}'),
                          ),
                          radius: 68.0,
                        ),
                      // Image(image: AssetImage('assets${album.albumArt}'), height:  Platform.isIOS? 136: 137, width: 300,),
                      SizedBox(height: 2,),
                      Text(album.albumTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(album.albumArtist, style: TextStyle(fontSize: 10)),
                      Platform.isIOS? SizedBox(height: 3,) : SizedBox(height: 0,) 
                    ],
                  ),
                ),
            ),
     );
  }
}