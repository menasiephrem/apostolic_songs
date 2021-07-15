
import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/widgets/audio_controler.dart';
import 'package:apostolic_songs/widgets/media_controler/MediaControler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'lyrics_page.dart';

class PlayerPage  extends StatelessWidget{  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("አሁን እየተጫወተ"),
        actions: [
          IconButton(
            icon: Icon(Icons.notes),
            onPressed: () {
             var item =  AudioService.currentMediaItem;
             if(item != null) {
               var lyric = Lyrics.fromMediaItem(item);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LyricsPage(lyric)),
              );
             }
            },
          )
        ]
      ),
      body: 
      StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        MediaItem item = snapshot.data;
        if(item == null) return Center(child: CircularProgressIndicator(),);
        Lyrics _lyrics = Lyrics.fromMediaItem(item);
        return Column(
              children:[
                SizedBox(height: 30),
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Image.asset(
                      "assets/images/${_lyrics?.albumId}.jpg".toLowerCase(),
                      alignment: Alignment.center,
                    )
                ),
                SizedBox(height: 60),
                Text(
                  _lyrics?.lyricTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)
                ),
                Text(
                  _lyrics?.lryicArtist,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey)
                ),
                SizedBox(height: 15),
                AudioServiceWidget(child: AudioControler(_lyrics, (){}, true)),
                SizedBox(height: 45),
                MusicBoardControls()
              ]
            );
      }
    )
    );
  }
}